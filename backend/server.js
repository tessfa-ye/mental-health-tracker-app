const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const dotenv = require("dotenv");
const chatRoutes = require("./routes/chatRoutes");

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error("MongoDB connection error:", err));

// Routes
app.use("/api/chat", chatRoutes);

// Test route
app.get("/ping", (req, res) => res.send("pong"));

const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));
