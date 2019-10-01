class Item
{
	int id;
	String name;
	int price;
	int qty;
	Item() //blank default constructor
	{}
	Item(int id, String name, int price, int qty)
	{
		this.id = id;
		this.name = name;
		this.price = price;
		this.qty = qty;
	}
	void out(Item I[])
	{
		for(int i=0;i<I.length;i++)
		{
			System.out.println(I[i].id + " " + I[i].name + " " + I[i].price + " " + I[i].qty);
	

		}
	}
}
class Sales extends Item
{
	int id;
	int qty;
	Sales() {}
	Sales(int id, int qty, Item I[])
	{
		this.id=id;
		this.qty=qty;
		for(int i=0;i<I.length;i++)
		{
			if(id==I[i].id)
			{	
				I[i].qty=I[i].qty-qty;
				break;
			}
		}
	}
}
class Purchase extends Item
{
	int id;
	int qty;
	Purchase() {}
	Purchase(int id, int qty, Item I[])
	{
		this.id=id;
		this.qty=qty;
		for(int i=0; i<I.length; i++)
		{
			if(id==I[i].id)
			{
				I[i].qty = I[i].qty+qty;
				break;
			}
		}
	}
}
class Account extends Sales
{
	int sum=0;
	Account() {}
	Account(Sales S[], Item I[])
	{
		for(int i=0;i<S.length;i++)
		{
			for(int j=0;j<I.length;j++)
			{
				if(S[i].id == I[j].id)
				{
					sum = sum + ((S[i].qty)*(I[j].price));
				}
			}
		}
		System.out.println("You have to pay Rs "+sum);
	}
}
class Inheritance
{
	public static void main(String args[])
	{
		Item i[] = new Item[5];
		i[0] = new Item(1, "bike",50000,3);
		i[1] = new Item(2, "car",80000,5);
		i[2] = new Item(3, "cycle",5000,10);
		i[3] = new Item(4, "activa",60000,5);
		i[4] = new Item(5, "toycar",1000,50);
		//i[0].out(i);
		Sales s[] = new Sales[3];
		s[0] = new Sales(1,2,i);
		s[1] = new Sales(2,1,i);
		s[2] = new Sales(5,10,i);
		//i[0].out(i);
		new Account(s,i);
	}
	
}		
