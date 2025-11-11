// controllers/chatController.js
const Message = require("../models/Message");
const { CohereClientV2 } = require("cohere-ai");
require("dotenv").config();

const cohere = new CohereClientV2({ token: process.env.COHERE_API_KEY });

exports.sendMessage = async (req, res) => {
  const { userId, message } = req.body;
  console.log("📩 Received from Flutter:", req.body);

  if (!userId || !message)
    return res.status(400).json({ error: "userId and message are required" });

  try {
    console.log("💬 Saving user message...");
    const userMsg = await Message.create({
      userId,
      role: "user",
      content: message,
      timestamp: new Date(),
    });

    console.log("🧠 Sending request to Cohere...");
    const cohereResponse = await cohere.chat({
      model: "command-a-03-2025",
      messages: [{ role: "user", content: message }],
      max_tokens: 500,
      temperature: 0.7,
    });

    console.log("✅ Cohere raw response:", JSON.stringify(cohereResponse, null, 2));

    const aiContent =
      cohereResponse.message?.content?.[0]?.text ||
      "Sorry, I couldn't generate a response.";

    console.log("🧩 AI Response text:", aiContent.slice(0, 80));

    const aiMsg = await Message.create({
      userId,
      role: "assistant",
      content: aiContent,
      timestamp: new Date(),
    });

    console.log("✅ AI message saved successfully!");
    res.json({ userMessage: userMsg, aiMessage: aiMsg });
  } catch (err) {
    console.error("❌ Error in sendMessage:", err);
    res.status(500).json({ error: err.message || "Failed to get AI response" });
  }
};

exports.getMessages = async (req, res) => {
  const { userId } = req.params;
  if (!userId) return res.status(400).json({ error: "userId required" });

  try {
    const messages = await Message.find({ userId }).sort({ timestamp: 1 });
    res.json(messages);
  } catch (err) {
    console.error("❌ Error in getMessages:", err.message);
    res.status(500).json({ error: "Failed to fetch messages" });
  }
};
