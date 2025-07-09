import React from "react";
export default function Notification({ message, onClose }: { message: string, onClose: () => void }) {
  if (!message) return null;
  return (
    <div style={{
      position: "fixed", top: 10, right: 10, background: "#222", color: "#fff", padding: "1em", borderRadius: "6px"
    }}>
      {message}
      <button onClick={onClose} style={{ marginLeft: 10, background: "#ffb800" }}>X</button>
    </div>
  );
}