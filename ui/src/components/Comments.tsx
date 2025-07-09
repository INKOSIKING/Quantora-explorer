import React, { useEffect, useState } from "react";
import { List, Input, Button, message } from "antd";
import api from "../api";

export function Comments({ target }) {
  const [comments, setComments] = useState([]);
  const [body, setBody] = useState("");
  useEffect(() => {
    api.get(`/community/comments/${target}`).then(r => setComments(r.data));
  }, [target]);

  const submit = async () => {
    await api.post("/community/comment", { target, body });
    setBody(""); message.success("Comment posted!");
    setComments(await api.get(`/community/comments/${target}`).then(r => r.data));
  };

  return (
    <div>
      <Input.TextArea rows={3} value={body} onChange={e => setBody(e.target.value)} />
      <Button onClick={submit} disabled={!body}>Submit</Button>
      <List
        dataSource={comments}
        renderItem={item => (
          <List.Item>
            <b>{item.user_id}</b> <span style={{ color: "#888" }}>{item.created_at}</span>
            <div>{item.body}</div>
          </List.Item>
        )}
      />
    </div>
  );
}