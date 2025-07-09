import WebSocket from 'isomorphic-ws';

export class QuantoraEventStream {
  private ws: WebSocket | null = null;
  private url: string;
  private reconnectTimeout: number;
  constructor(url: string, reconnectTimeout = 5000) {
    this.url = url;
    this.reconnectTimeout = reconnectTimeout;
  }
  subscribe(event: string, cb: (msg: any) => void) {
    this.ws = new WebSocket(this.url);
    this.ws.onopen = () => this.ws?.send(JSON.stringify({ subscribe: event }));
    this.ws.onmessage = (m) => cb(JSON.parse(m.data as string));
    this.ws.onerror = () => this.reconnect(event, cb);
    this.ws.onclose = () => this.reconnect(event, cb);
  }
  private reconnect(event: string, cb: (msg: any) => void) {
    setTimeout(() => this.subscribe(event, cb), this.reconnectTimeout);
  }
  unsubscribe() {
    this.ws?.close();
    this.ws = null;
  }
}