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
        .setDescription('Generate the interactive control panel'),
    new SlashCommandBuilder()
        .setName('blacklist')
        .setDescription('Blacklist a user')
        .addUserOption(option => option.setName('user').setDescription('The Discord user to blacklist').setRequired(true)),
    new SlashCommandBuilder()
        .setName('unblacklist')
        .setDescription('Unblacklist a user')
        .addUserOption(option => option.setName('user').setDescription('The Discord user to unblacklist').setRequired(true)),
    new SlashCommandBuilder()
        .setName('reset_hwid')
        .setDescription('Reset HWID for a user')
        .addUserOption(option => option.setName('user').setDescription('The Discord user to reset HWID').setRequired(true))
].map(command => command.toJSON());

const parseDuration = (str) => {
    str = str.toLowerCase();
    if (str === 'l') return null;

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
            return interaction.reply({ embeds: [new EmbedBuilder().setDescription('You do not have permission to use this command.').setColor('#e74c3c')], ephemeral: true });
        }

        if (interaction.commandName === 'createkey') {
            const durationStr = interaction.options.getString('duration');
            const durationMs = parseDuration(durationStr);

            if (durationMs === undefined) {
                return interaction.reply({ embeds: [new EmbedBuilder().setDescription('Invalid duration. Use 1h, 1d, 2d, 7d, 1w, 1m, 1y, or l (lifetime).').setColor('#e74c3c')], ephemeral: true });
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
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Error generating key.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.commandName === 'key') {
            try {
                const cooldownMs = 24 * 60 * 60 * 1000;
                const lastFreeKey = await License.findOne({ discordId: interaction.user.id, isFree: true }).sort({ createdAt: -1 });

                if (lastFreeKey && (Date.now() - lastFreeKey.createdAt.getTime()) < cooldownMs) {
                    const availableAt = Math.floor((lastFreeKey.createdAt.getTime() + cooldownMs) / 1000);
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription(`You can generate another free key <t:${availableAt}:R>.`).setColor('#e74c3c')], ephemeral: true });
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
                    .setDescription('Here is your 24-hour key!\nBefore you use the script, go to <#1544012102044352532> to redeem it and get your role.')
                    .addFields(
                        { name: 'Key', value: `\`${newKey}\`` },
                        { name: 'Duration', value: '24 hours' }
                    )
                    .setColor('#2ecc71')
                    .setTimestamp();

                await interaction.reply({ embeds: [embed], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Error generating free key.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.commandName === 'keyinfo') {
            const keyString = interaction.options.getString('key');

            try {
                const license = await License.findOne({ key: keyString }).populate('claimedBy', 'username');

                if (!license) {
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription('Key not found.').setColor('#e74c3c')], ephemeral: true });
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
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Error fetching key info.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.commandName === 'blacklist') {
            const targetUser = interaction.options.getUser('user');
            try {
                const user = await User.findOne({ discordId: targetUser.id });
                if (!user) return interaction.reply({ embeds: [new EmbedBuilder().setDescription('That Discord user has not registered an account yet.').setColor('#e74c3c')], ephemeral: true });
                user.banned = true;
                await user.save();
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription(`User **${user.username}** (<@${targetUser.id}>) has been blacklisted.`).setColor('#2ecc71')], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Error blacklisting user.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.commandName === 'unblacklist') {
            const targetUser = interaction.options.getUser('user');
            try {
                const user = await User.findOne({ discordId: targetUser.id });
                if (!user) return interaction.reply({ embeds: [new EmbedBuilder().setDescription('That Discord user has not registered an account yet.').setColor('#e74c3c')], ephemeral: true });
                user.banned = false;
                await user.save();
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription(`User **${user.username}** (<@${targetUser.id}>) has been unblacklisted.`).setColor('#2ecc71')], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Error unblacklisting user.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.commandName === 'reset_hwid') {
            const targetUser = interaction.options.getUser('user');
            try {
                const user = await User.findOne({ discordId: targetUser.id });
                if (!user) return interaction.reply({ embeds: [new EmbedBuilder().setDescription('That Discord user has not registered an account yet.').setColor('#e74c3c')], ephemeral: true });
                user.hwid = null;
                user.hwidResets = (user.hwidResets || 0) + 1;
                user.lastReset = new Date();
                await user.save();
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription(`HWID for **${user.username}** (<@${targetUser.id}>) has been reset.`).setColor('#2ecc71')], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Error resetting HWID.').setColor('#2ecc71')], ephemeral: true });
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
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription('You have not linked a key yet. Please use the "Redeem Key" button first.').setColor('#2ecc71')], ephemeral: true });
                }

                const roleId = '1544012798097367040';
                const hasRole = interaction.member.roles.cache.has(roleId);

                if (!hasRole) {
                    const role = interaction.guild.roles.cache.get(roleId);
                    if (role) {
                        await interaction.member.roles.add(role);
                        const successEmbed = new EmbedBuilder().setDescription('Role successfully given!').setColor('#2ecc71');
                        return interaction.reply({ embeds: [successEmbed], ephemeral: true });
                    } else {
                        return interaction.reply({ embeds: [new EmbedBuilder().setDescription('Role not found in the server.').setColor('#e74c3c')], ephemeral: true });
                    }
                } else {
                    const errorEmbed = new EmbedBuilder()
                        .setTitle('Unable to give role')
                        .setDescription(`You already have the <@&${roleId}> role!`)
                        .setColor('#ff0000');

                    await interaction.reply({ embeds: [errorEmbed], ephemeral: true });
                }
            } catch (err) {
                console.error(err);
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('An error occurred.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.customId === 'panel_stats') {
            try {
                const license = await License.findOne({ discordId: interaction.user.id });
                if (!license) {
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription('You have not linked a key yet.').setColor('#2ecc71')], ephemeral: true });
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
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('An error occurred.').setColor('#e74c3c')], ephemeral: true });
            }
        } else if (interaction.customId.startsWith('panel_')) {
            await interaction.reply({ embeds: [new EmbedBuilder().setDescription('This feature is coming soon!').setColor('#e74c3c')], ephemeral: true });
        }
    } else if (interaction.isModalSubmit()) {
        if (interaction.customId === 'redeem_modal') {
            const keyInput = interaction.fields.getTextInputValue('key_input');

            try {
                const license = await License.findOne({ key: keyInput });

                if (!license) {
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription('Invalid license key.').setColor('#e74c3c')], ephemeral: true });
                }

                if (license.claimedBy) {
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription('This key has already been fully claimed and used.').setColor('#e74c3c')], ephemeral: true });
                }

                if (license.discordId && license.discordId !== interaction.user.id) {
                    return interaction.reply({ embeds: [new EmbedBuilder().setDescription('This key is already linked to another Discord account.').setColor('#2ecc71')], ephemeral: true });
                }

                license.discordId = interaction.user.id;
                await license.save();

                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('Key successfully linked to your Discord account! Please click the **Get Role** button to receive your role.').setColor('#2ecc71')], ephemeral: true });
            } catch (err) {
                console.error(err);
                await interaction.reply({ embeds: [new EmbedBuilder().setDescription('An error occurred while processing your key.').setColor('#e74c3c')], ephemeral: true });
            }
        }
    }
});

module.exports = {
    start: () => {
        if (process.env.TOKEN && process.env.OWNER) {
            client.login(process.env.TOKEN.trim()).catch(console.error);
        } else {
            console.log('Missing TOKEN or OWNER in .env, Discord Bot not started.');
        }
    },
    sendDM: async (discordId, content, embed = null) => {
        try {
            const user = await client.users.fetch(discordId);
            if (user) {
                const options = { content };
                if (embed) options.embeds = [embed];
                await user.send(options);
                return true;
            }
            return false;
        } catch (error) {
            console.error('Error sending DM:', error);
            return false;
        }
    }
};
