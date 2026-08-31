const { Client, GatewayIntentBits, REST, Routes, SlashCommandBuilder, EmbedBuilder, ActionRowBuilder, ButtonBuilder, ButtonStyle, ModalBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');
const mongoose = require('mongoose');
const License = require('./models/License');
const User = require('./models/User');

const client = new Client({ intents: [GatewayIntentBits.Guilds] });

const commands = [
    new SlashCommandBuilder()
        .setName('key')
        .setDescription('Generate a new license key')
        .addStringOption(option =>
            option.setName('duration')
                .setDescription('Duration (1h, 1d, 2d, 7d, 1w, 1m, 1y, l)')
                .setRequired(true)
        ),
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
        if (interaction.user.id !== process.env.OWNER) {
            return interaction.reply({ content: 'You do not have permission to use this command.', ephemeral: true });
        }

        if (interaction.commandName === 'key') {
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
                
                const roleId = '1544012798097367040';
                if (interaction.guild) {
                    const role = interaction.guild.roles.cache.get(roleId);
                    if (role) {
                        await interaction.member.roles.add(role).catch(console.error);
                    } else {
                        console.log(`Role ${roleId} not found in guild.`);
                    }
                }
                
                await interaction.reply({ content: 'Key successfully linked to your Discord account! You have received your role. You can now use the key in the script.', ephemeral: true });
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
