const Employee = require("../models/job");

const MATCH_EXPIRY_HOURS = 24;

const checkExpiredMatches = async () => {
  const now = new Date();
  const expired = await Employee.find({
    matchFoundAt: { $exists: true },
    applied: false,
    eligible: true,
  });

  const disqualified = [];

  for (const emp of expired) {
    const hoursPassed = (now - emp.matchFoundAt) / 1000 / 60 / 60;
    if (hoursPassed >= MATCH_EXPIRY_HOURS) {
      emp.eligible = false;
      emp.matchFoundAt = undefined;
      await emp.save();
      disqualified.push(emp.empId);
    }
  }

  return disqualified;
};

module.exports = checkExpiredMatches;
