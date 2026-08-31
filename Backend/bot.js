const { Client, GatewayIntentBits, REST, Routes, SlashCommandBuilder, EmbedBuilder } = require('discord.js');
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
        )
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
    if (!interaction.isChatInputCommand()) return;

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

            await interaction.reply({ embeds: [embed], ephemeral: false });
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

            await interaction.reply({ embeds: [embed], ephemeral: false });
        } catch (err) {
            console.error(err);
            await interaction.reply({ content: 'Error fetching key info.', ephemeral: true });
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
