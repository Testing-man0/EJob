const mongoose = require("mongoose");

const notificationSchema = new mongoose.Schema({
  empId: {
    type: String,
    required: true,
  },
  message: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// ✅ Add compound index to prevent duplicates per empId + message
notificationSchema.index({ empId: 1, message: 1 }, { unique: true });

module.exports = mongoose.model("Notification", notificationSchema);
