let items: any[] = [];
let id = 1;

export async function listItem(seller: string, item: any, price: number) {
  const itemId = id++;
  items.push({ itemId, seller, item, price, sold: false });
  return { itemId, status: "listed" };
}

export async function buyItem(buyer: string, itemId: number) {
  const item = items.find(i => i.itemId === itemId && !i.sold);
  if (!item) return { error: "not found or already sold" };
  item.sold = true;
  item.buyer = buyer;
  // Integrate with Quantora Chain for payment
  return { status: "success", itemId, buyer };
}

export async function getItems() {
  return items.filter(i => !i.sold);
}