//const express = require('express');
//const http = require('http');
//const { Server } = require('socket.io');
//const cors = require('cors');
//
//const app = express();
//app.use(cors());
//
//const server = http.createServer(app);
//const io = new Server(server, {
//  cors: {
//    origin: '*',
//  },
//});
//
//let users = {}; // userId: { socketId, lat, lon }
//
//function calculateDistance(lat1, lon1, lat2, lon2) {
//  const R = 6371; // Earth radius in km
//  const dLat = (lat2 - lat1) * Math.PI / 180;
//  const dLon = (lon2 - lon1) * Math.PI / 180;
//  const a =
//    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
//    Math.cos(lat1 * Math.PI / 180) *
//      Math.cos(lat2 * Math.PI / 180) *
//      Math.sin(dLon / 2) *
//      Math.sin(dLon / 2);
//  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
//  return R * c;
//}
//
//io.on('connection', (socket) => {
//  console.log(`🔌 New user connected: ${socket.id}`);
//
//  socket.on('register', (data) => {
//    // Expected: { userId, lat, lon }
//    users[data.userId] = { socketId: socket.id, lat: data.lat, lon: data.lon };
//    console.log(`✅ Registered: ${data.userId}`);
//  });
//
//  socket.on('update_location', (data) => {
//    if (users[data.userId]) {
//      users[data.userId].lat = data.lat;
//      users[data.userId].lon = data.lon;
//    }
//  });
//
//socket.on('send_alert', (data) => {
//  console.log(`🚨 ALERT from ${data.userId} at (${data.lat}, ${data.lon})`);
//
//  Object.entries(users).forEach(([uid, info]) => {
//    if (uid === data.userId) return;
//
//    const dist = calculateDistance(data.lat, data.lon, info.lat, info.lon);
//
//    console.log(`📏 Distance to ${uid} at (${info.lat}, ${info.lon}) = ${dist.toFixed(2)} km`);
//
//    if (dist <= 5) {
//      io.to(info.socketId).emit('receive_alert', {
//        from: data.userId,
//        name: data.name,
//        lat: data.lat,
//        lon: data.lon,
//        distance: dist.toFixed(2),
//      });
//
//      console.log(`📢 Alert sent to ${uid} (${dist.toFixed(2)} km)`);
//    }
//  });
//});
//
//
//  socket.on('disconnect', () => {
//    console.log(`❌ User disconnected: ${socket.id}`);
//    for (const [userId, userData] of Object.entries(users)) {
//      if (userData.socketId === socket.id) {
//        delete users[userId];
//        console.log(`🧹 Removed user: ${userId}`);
//        break;
//      }
//    }
//  });
//});
//
//server.listen(3000, () => {
//  console.log('✅ WebSocket server running on http://localhost:3000');
//});


const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

let users = {}; // userId: { socketId, lat, lon, name }

function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) *
      Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

io.on('connection', (socket) => {
  console.log(`🔌 New user connected: ${socket.id}`);

  socket.on('register', (data) => {
    // Expected: { userId, lat, lon, name }
    users[data.userId] = {
      socketId: socket.id,
      lat: data.lat,
      lon: data.lon,
      name: data.name || 'Anonymous'
    };
    console.log(`✅ Registered: ${data.userId} (${data.name})`);
  });

  socket.on('update_location', (data) => {
    if (users[data.userId]) {
      users[data.userId].lat = data.lat;
      users[data.userId].lon = data.lon;
    }
  });

  socket.on('send_alert', (data) => {
    console.log(`🚨 ALERT from ${data.userId} at (${data.lat}, ${data.lon})`);

    const sender = users[data.userId];
    if (!sender) return;

    Object.entries(users).forEach(([uid, info]) => {
      if (uid === data.userId) return;

      const dist = calculateDistance(data.lat, data.lon, info.lat, info.lon);
      console.log(`📏 Distance to ${uid} = ${dist.toFixed(2)} km`);

      if (dist <= 5) {
        io.to(info.socketId).emit('receive_alert', {
          from: data.userId,
          name: sender.name, // ✅ Send the stored name
          lat: data.lat,
          lon: data.lon,
          distance: dist.toFixed(2),
        });

        console.log(`📢 Alert sent to ${uid} (${dist.toFixed(2)} km)`);
      }
    });
  });

  socket.on('disconnect', () => {
    console.log(`❌ User disconnected: ${socket.id}`);
    for (const [userId, userData] of Object.entries(users)) {
      if (userData.socketId === socket.id) {
        delete users[userId];
        console.log(`🧹 Removed user: ${userId}`);
        break;
      }
    }
  });
});

server.listen(3000, () => {
  console.log('✅ WebSocket server running on http://localhost:3000');
});
