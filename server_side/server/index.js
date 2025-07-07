const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config(); // Load env variables

const jobRouter = require("./routers/job");
const notificationRouter = require("./routers/notification");
const matchRouter = require("./routers/matches");

const app = express();
app.use(cors());
app.use(express.json());

// ✅ MongoDB Connection
mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB connected Successfully"))
  .catch((err) => console.error("❌ MongoDB connection error:", err));

// ✅ API Routes
app.use("/api/jobs", jobRouter); // Includes /add, /all, /mutual, /apply/:empId, /status/:empId
app.use("/api/notifications", notificationRouter); // Notification routes
app.use("/api/matches", matchRouter); // Match viewing routes

// ✅ Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);
