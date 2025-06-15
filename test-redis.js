const redis = require('redis');

// Create a Redis client
const client = redis.createClient({
  url: 'redis://localhost:6379'
});

client.on('error', (err) => {
  console.error('Redis Error:', err);
  process.exit(1);
});

client.on('connect', () => {
  console.log('Connected to Redis!');
  client.quit();
  process.exit(0);
});

// Connect to Redis
(async () => {
  await client.connect();
})();
