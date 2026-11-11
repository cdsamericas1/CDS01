// Sample articles based on ART400.SQLRPGLE — ArticleItem data structure
// Fields: id(6), description(50), familyCode(3), familyDescription, salePrice, stock

export interface ArticleItem {
  id: string;               // Char(6)  — ARID
  description: string;      // Char(50) — ARDESC
  familyCode: string;       // Char(3)  — ARTIFA
  familyDescription: string;// Char(50) — FADESC (JOIN FAMILLY)
  salePrice: number;        // Packed(7:2) — ARSALEPR
  stock: number;            // Packed(5:0) — ARSTOCK
}

export const sampleArticles: ArticleItem[] = [
  { id: 'ART001', description: 'Laptop Computer 15 inch',           familyCode: 'ELE', familyDescription: 'Electronics',     salePrice: 899.99, stock: 25  },
  { id: 'ART002', description: 'Wireless Mouse',                    familyCode: 'ELE', familyDescription: 'Electronics',     salePrice:  29.99, stock: 150 },
  { id: 'ART003', description: 'Bluetooth Headphones',              familyCode: 'ELE', familyDescription: 'Electronics',     salePrice:  79.99, stock:  80 },
  { id: 'ART004', description: 'Office Chair Ergonomic',            familyCode: 'FUR', familyDescription: 'Furniture',       salePrice: 249.99, stock:  30 },
  { id: 'ART005', description: 'Desk 120x60cm White',               familyCode: 'FUR', familyDescription: 'Furniture',       salePrice: 189.99, stock:  20 },
  { id: 'ART006', description: 'Programming Guide 2024',            familyCode: 'BOO', familyDescription: 'Books',           salePrice:  39.99, stock:  60 },
  { id: 'ART007', description: 'T-Shirt Cotton Blue M',             familyCode: 'CLO', familyDescription: 'Clothing',        salePrice:  19.99, stock: 100 },
  { id: 'ART008', description: 'Yoga Mat Premium',                  familyCode: 'SPO', familyDescription: 'Sports Equipment',salePrice:  39.99, stock:  60 },
  { id: 'ART009', description: 'Organic Coffee Beans 1kg',          familyCode: 'FOO', familyDescription: 'Food',            salePrice:  24.99, stock: 120 },
  { id: 'ART010', description: 'Vacuum Cleaner Cordless',           familyCode: 'HOM', familyDescription: 'Home Appliances', salePrice: 199.99, stock:  30 },
];
