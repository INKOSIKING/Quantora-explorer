package quantora

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

type Client struct {
	BaseURL string
}

func New(baseURL string) *Client {
	return &Client{BaseURL: baseURL}
}

func (c *Client) GetBlock(hash string) (map[string]interface{}, error) {
	resp, err := http.Get(fmt.Sprintf("%s/block/%s", c.BaseURL, hash))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var result map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&result)
	return result, nil
}

func (c *Client) Search(q string) (map[string]interface{}, error) {
	resp, err := http.Get(fmt.Sprintf("%s/search?q=%s", c.BaseURL, q))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var result map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&result)
	return result, nil
}

func (c *Client) NewOrder(token, pair, orderType string, size float64, price *float64) (map[string]interface{}, error) {
	order := map[string]interface{}{"pair": pair, "type": orderType, "size": size}
	if price != nil {
		order["price"] = *price
	}
	b, _ := json.Marshal(order)
	req, _ := http.NewRequest("POST", fmt.Sprintf("%s/order", c.BaseURL), bytes.NewReader(b))
	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Content-Type", "application/json")
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var result map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&result)
	return result, nil
}