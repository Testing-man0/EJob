const mongoose = require("mongoose");

const employeeSchema = new mongoose.Schema({
  empId: {
    type: String,
    required: true,
    unique: true,
  },
  name: String,
  currentPlace: String,
  desiredPlace: String,
  designation: String,
  createdAt: {
    type: Date,
    default: Date.now,
  },

  // 🔽 NEW FIELDS FOR MATCH + APPLY LOGIC
  matchFoundAt: {
    type: Date,
    default: null, // Only set when a match is found
  },
  applied: {
    type: Boolean,
    default: false, // Will be set to true if user applies for transfer
  },
  eligible: {
    type: Boolean,
    default: true, // Set to false if employee fails to apply in time
  }
});

// Optional: avoid duplicate index error
employeeSchema.index({ empId: 1 }, { unique: true });

module.exports = mongoose.model("Employee", employeeSchema);
