const express = require("express");
const router = express.Router();
const Notification = require("../models/notification");

// ✅ Save a new notification (with duplicate check)
router.post("/add", async (req, res) => {
  const { empId, message } = req.body;

  try {
    // Check if notification already exists
    const exists = await Notification.findOne({ empId, message });

    if (exists) {
      return res.status(409).json({ message: "Notification already exists" });
    }

    const notification = new Notification({ empId, message });
    await notification.save();
    res.status(200).json({ message: "Notification saved" });
  } catch (err) {
    res.status(500).json({ error: "Failed to save notification", details: err });
  }
});

// 📩 Get all notifications for an employee
router.get("/:empId", async (req, res) => {
  const { empId } = req.params;

  try {
    const notifications = await Notification.find({ empId }).sort({ createdAt: -1 });
    res.status(200).json(notifications);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch notifications", details: err });
  }
});

module.exports = router;
