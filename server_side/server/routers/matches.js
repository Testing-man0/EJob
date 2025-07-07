const express = require("express");
const router = express.Router();
const Employee = require("../models/job");

// 📦 Get all matched employee pairs with status
router.get("/all-matches", async (req, res) => {
  try {
    const employees = await Employee.find({ matchFoundAt: { $exists: true } }).sort({ matchFoundAt: -1 });

    const matchedEmpIds = new Set();
    const matchedPairs = [];

    for (let i = 0; i < employees.length; i++) {
      const a = employees[i];
      if (matchedEmpIds.has(a.empId)) continue;

      for (let j = i + 1; j < employees.length; j++) {
        const b = employees[j];
        if (matchedEmpIds.has(b.empId)) continue;

        const isValidMatch =
          a.desiredPlace === b.currentPlace &&
          b.desiredPlace === a.currentPlace &&
          a.designation === b.designation &&
          a.matchFoundAt &&
          b.matchFoundAt &&
          Math.abs(new Date(a.matchFoundAt) - new Date(b.matchFoundAt)) < 60 * 1000; // 1 min diff

        if (isValidMatch) {
          matchedEmpIds.add(a.empId);
          matchedEmpIds.add(b.empId);
          matchedPairs.push({
            empA: {
              empId: a.empId,
              name: a.name,
              currentPlace: a.currentPlace,
              desiredPlace: a.desiredPlace,
              designation: a.designation,
              applied: a.applied,
              eligible: a.eligible,
              matchFoundAt: a.matchFoundAt
            },
            empB: {
              empId: b.empId,
              name: b.name,
              currentPlace: b.currentPlace,
              desiredPlace: b.desiredPlace,
              designation: b.designation,
              applied: b.applied,
              eligible: b.eligible,
              matchFoundAt: b.matchFoundAt
            }
          });

          break;
        }
      }
    }

    res.json({ matchedPairs });
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch matched pairs", details: err });
  }
});

module.exports = router;
