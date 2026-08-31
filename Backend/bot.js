const { Client, GatewayIntentBits, REST, Routes, SlashCommandBuilder, EmbedBuilder, ActionRowBuilder, ButtonBuilder, ButtonStyle, ModalBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');
const mongoose = require('mongoose');
const License = require('./models/License');
const User = require('./models/User');

const client = new Client({ intents: [GatewayIntentBits.Guilds] });

const commands = [
    new SlashCommandBuilder()
        .setName('createkey')
        .setDescription('Generate a new license key')
        .addStringOption(option =>
            option.setName('duration')
                .setDescription('Duration (1h, 1d, 2d, 7d, 1w, 1m, 1y, l)')
                .setRequired(true)
        ),
    new SlashCommandBuilder()
        .setName('key')
        .setDescription('Get a free 24-hour key'),
    new SlashCommandBuilder()
        .setName('keyinfo')
        .setDescription('Get information about a key')
        .addStringOption(option =>
            option.setName('key')
                .setDescription('The license key')
                .setRequired(true)
        ),
    new SlashCommandBuilder()
        .setName('panel')
        .setDescription('Generate the interactive control panel')
].map(command => command.toJSON());

const parseDuration = (str) => {
    str = str.toLowerCase();
    if (str === 'l') return null; // lifetime

    const amount = parseInt(str);
    if (isNaN(amount)) return undefined;

    if (str.includes('h')) return amount * 60 * 60 * 1000;
    if (str.includes('d')) return amount * 24 * 60 * 60 * 1000;
    if (str.includes('w')) return amount * 7 * 24 * 60 * 60 * 1000;
    if (str.includes('m')) return amount * 30 * 24 * 60 * 60 * 1000;
    if (str.includes('y')) return amount * 365 * 24 * 60 * 60 * 1000;

    return undefined;
};

const generateKey = () => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let key = '';
    for (let i = 0; i < 32; i++) {
        if (i > 0 && i % 8 === 0) key += '-';
        key += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return key;
};

client.on('ready', async () => {
    console.log(`Bot logged in as ${client.user.tag}`);
    try {
        const rest = new REST({ version: '10' }).setToken(process.env.TOKEN);
        await rest.put(
            Routes.applicationCommands(client.user.id),
            { body: commands }
        );
        console.log('Successfully registered application commands.');
    } catch (error) {
        console.error('Error registering commands:', error);
    }
});

client.on('interactionCreate', async interaction => {
    if (interaction.isChatInputCommand()) {
        if (interaction.user.id !== process.env.OWNER && !['panel', 'key'].includes(interaction.commandName)) {
            return interaction.reply({ content: 'You do not have permission to use this command.', ephemeral: true });
        }

        if (interaction.commandName === 'createkey') {
            const durationStr = interaction.options.getString('duration');
            const durationMs = parseDuration(durationStr);

            if (durationMs === undefined) {
                return interaction.reply({ content: 'Invalid duration. Use 1h, 1d, 2d, 7d, 1w, 1m, 1y, or l (lifetime).', ephemeral: true });
            }

            const key = generateKey();

            try {
                const license = new License({
                    key: key,
                    durationMs: durationMs
                });
                await license.save();

                const embed = new EmbedBuilder()
                    .setTitle('Key Generated')
                    .addFields(
                        { name: 'Key', value: `\`${key}\`` },
                        { name: 'Duration', value: durationStr === 'l' ? 'Lifetime' : durationStr }
                    )
                    .setColor('#2ecc71')
                    .setTimestamp();

                await interaction.reply({ embeds: [embed], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ content: 'Error generating key.', ephemeral: true });
            }
        } else if (interaction.commandName === 'key') {
            try {
                const cooldownMs = 24 * 60 * 60 * 1000;
                const lastFreeKey = await License.findOne({ discordId: interaction.user.id, isFree: true }).sort({ createdAt: -1 });

                if (lastFreeKey && (Date.now() - lastFreeKey.createdAt.getTime()) < cooldownMs) {
                    const availableAt = Math.floor((lastFreeKey.createdAt.getTime() + cooldownMs) / 1000);
                    return interaction.reply({ content: `You can generate another free key <t:${availableAt}:R>.`, ephemeral: true });
                }

                const newKey = generateKey();
                const license = new License({
                    key: newKey,
                    durationMs: cooldownMs,
                    discordId: interaction.user.id,
                    isFree: true
                });
                await license.save();

                const embed = new EmbedBuilder()
                    .setTitle('Free Key Generated')
                    .setDescription('Here is your 24-hour key! It is already linked to your Discord account. You can now use it directly in the script.')
                    .addFields(
                        { name: 'Key', value: `\`${newKey}\`` },
                        { name: 'Duration', value: '24 hours' }
                    )
                    .setColor('#2ecc71')
                    .setTimestamp();

                await interaction.reply({ embeds: [embed], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ content: 'Error generating free key.', ephemeral: true });
            }
        } else if (interaction.commandName === 'keyinfo') {
            const keyString = interaction.options.getString('key');

            try {
                const license = await License.findOne({ key: keyString }).populate('claimedBy', 'username');

                if (!license) {
                    return interaction.reply({ content: 'Key not found.', ephemeral: true });
                }

                let status = license.claimedBy ? 'Claimed' : 'Unclaimed';
                let claimedByStr = license.claimedBy ? license.claimedBy.username : 'N/A';
                let claimedAtStr = license.claimedAt ? license.claimedAt.toLocaleString() : 'N/A';

                let durationStr = 'Lifetime';
                if (license.durationMs !== null) {
                    durationStr = `${license.durationMs / (1000 * 60 * 60 * 24)} days`;
                }

                const embed = new EmbedBuilder()
                    .setTitle('Key Information')
                    .addFields(
                        { name: 'Key', value: `\`${license.key}\`` },
                        { name: 'Duration', value: durationStr, inline: true },
                        { name: 'Status', value: status, inline: true },
                        { name: 'Claimed By', value: claimedByStr, inline: true },
                        { name: 'Claimed At', value: claimedAtStr, inline: true }
                    )
                    .setColor(license.claimedBy ? '#e74c3c' : '#2ecc71')
                    .setTimestamp();

                await interaction.reply({ embeds: [embed], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ content: 'Error fetching key info.', ephemeral: true });
            }
        } else if (interaction.commandName === 'panel') {
            const embed = new EmbedBuilder()
                .setTitle('Volt UI')
                .setDescription("This control panel is for the project: **Volt UI**\nIf you're a buyer, click on the buttons below to redeem your key, get the script or get your role")
                .setColor('#2b2d31');

            const row = new ActionRowBuilder().addComponents(
                new ButtonBuilder().setCustomId('panel_redeem').setLabel('🔑 Redeem Key').setStyle(ButtonStyle.Success),
                new ButtonBuilder().setCustomId('panel_script').setLabel('📜 Get Script').setStyle(ButtonStyle.Primary),
                new ButtonBuilder().setCustomId('panel_role').setLabel('👤 Get Role').setStyle(ButtonStyle.Primary),
                new ButtonBuilder().setCustomId('panel_hwid').setLabel('⚙️ Reset HWID').setStyle(ButtonStyle.Secondary),
                new ButtonBuilder().setCustomId('panel_stats').setLabel('📊 Get Stats').setStyle(ButtonStyle.Secondary)
            );

            await interaction.reply({ embeds: [embed], components: [row] });
        }
    } else if (interaction.isButton()) {
        if (interaction.customId === 'panel_redeem') {
            const modal = new ModalBuilder()
                .setCustomId('redeem_modal')
                .setTitle('Redeem License Key');

            const keyInput = new TextInputBuilder()
                .setCustomId('key_input')
                .setLabel('Enter script key below: *')
                .setStyle(TextInputStyle.Short)
                .setRequired(true);

            const actionRow = new ActionRowBuilder().addComponents(keyInput);
            modal.addComponents(actionRow);

            await interaction.showModal(modal);
        } else if (interaction.customId === 'panel_role') {
            try {
                const license = await License.findOne({ discordId: interaction.user.id });
                if (!license) {
                    return interaction.reply({ content: 'You have not linked a key yet. Please use the "Redeem Key" button first.', ephemeral: true });
                }

                const roleId = '1544012798097367040';
                const hasRole = interaction.member.roles.cache.has(roleId);

                if (!hasRole) {
                    const role = interaction.guild.roles.cache.get(roleId);
                    if (role) {
                        await interaction.member.roles.add(role);
                        return interaction.reply({ content: 'Role successfully given!', ephemeral: true });
                    } else {
                        return interaction.reply({ content: 'Role not found in the server.', ephemeral: true });
                    }
                } else {
                    const user = await User.findOne({ discordId: interaction.user.id });

                    const errorEmbed = new EmbedBuilder()
                        .setTitle('Unable to give role')
                        .setDescription(`You already have the <@&${roleId}> role!`)
                        .setColor('#ff0000');

                    const statsEmbed = new EmbedBuilder()
                        .setTitle('Stats')
                        .setColor('#1e1e1e')
                        .setDescription(
                            `**Total Executions:** ${user ? user.executions : 0} 🧠\n` +
                            `**HWID Status:** ${user && user.hwid ? 'Assigned ✅' : 'Unassigned ❌'}\n` +
                            `**Key:** (click to reveal) ||${license.key}|| 🔒\n` +
                            `**Total HWID Resets:** ${user ? user.hwidResets : 0} ⚙️\n` +
                            `**Last Reset:** ${user && user.lastReset ? `<t:${Math.floor(user.lastReset.getTime() / 1000)}:R>` : 'Never'} 📅\n` +
                            `**Expires At:** ${license.durationMs === null ? 'Never 📅' : (user && user.subscriptionEnd ? `<t:${Math.floor(user.subscriptionEnd.getTime() / 1000)}:d> 📅` : 'Unknown 📅')}\n` +
                            `**Banned:** ${user && user.banned ? 'Yes 🔴' : 'No ⛔'}`
                        );

                    await interaction.reply({ embeds: [errorEmbed, statsEmbed], ephemeral: true });
                }
            } catch (err) {
                console.error(err);
                await interaction.reply({ content: 'An error occurred.', ephemeral: true });
            }
        } else if (interaction.customId === 'panel_stats') {
            try {
                const license = await License.findOne({ discordId: interaction.user.id });
                if (!license) {
                    return interaction.reply({ content: 'You have not linked a key yet.', ephemeral: true });
                }
                
                const user = await User.findOne({ discordId: interaction.user.id });
                
                const statsEmbed = new EmbedBuilder()
                    .setTitle('Stats')
                    .setColor('#1e1e1e')
                    .setDescription(
                        `**Total Executions:** ${user ? user.executions : 0} 🧠\n` +
                        `**HWID Status:** ${user && user.hwid ? 'Assigned ✅' : 'Unassigned ❌'}\n` +
                        `**Key:** (click to reveal) ||${license.key}|| 🔒\n` +
                        `**Total HWID Resets:** ${user ? user.hwidResets : 0} ⚙️\n` +
                        `**Last Reset:** ${user && user.lastReset ? `<t:${Math.floor(user.lastReset.getTime() / 1000)}:R>` : 'Never'} 📅\n` +
                        `**Expires At:** ${license.durationMs === null ? 'Never 📅' : (user && user.subscriptionEnd ? `<t:${Math.floor(user.subscriptionEnd.getTime() / 1000)}:d> 📅` : 'Unknown 📅')}\n` +
                        `**Banned:** ${user && user.banned ? 'Yes 🔴' : 'No ⛔'}`
                    );
                    
                await interaction.reply({ embeds: [statsEmbed], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ content: 'An error occurred.', ephemeral: true });
            }
        } else if (interaction.customId.startsWith('panel_')) {
            await interaction.reply({ content: 'This feature is coming soon!', ephemeral: true });
        }
    } else if (interaction.isModalSubmit()) {
        if (interaction.customId === 'redeem_modal') {
            const keyInput = interaction.fields.getTextInputValue('key_input');

            try {
                const license = await License.findOne({ key: keyInput });

                if (!license) {
                    return interaction.reply({ content: 'Invalid license key.', ephemeral: true });
                }

                if (license.claimedBy) {
                    return interaction.reply({ content: 'This key has already been fully claimed and used.', ephemeral: true });
                }

                if (license.discordId && license.discordId !== interaction.user.id) {
                    return interaction.reply({ content: 'This key is already linked to another Discord account.', ephemeral: true });
                }

                license.discordId = interaction.user.id;
                await license.save();

                await interaction.reply({ content: 'Key successfully linked to your Discord account! Please click the **Get Role** button to receive your role.', ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ content: 'An error occurred while processing your key.', ephemeral: true });
            }
        }
    }
});

module.exports = {
    start: () => {
        if (process.env.TOKEN && process.env.OWNER) {
            client.login(process.env.TOKEN).catch(console.error);
        } else {
            console.log('Missing TOKEN or OWNER in .env, Discord Bot not started.');
        }
    }
};
