/*
 * Cash register program for school, written in D instead of C++
 *
 * A few notes on the D Language:
 * - Immutability is similar to const
 * - In D, a string is an immutable dynamic array of unicode characters. Because I need my strings
 *        to be mutable, then I use char[] instead of string. String literals can be implicitly converted to char[]
 * - Input and output is handled via functions instead of using streams, like in C. writeln() writes a line,
 *        write() just writes at the current insertion point. readln() takes a string, and reads a line. strip() is used to
 *        remove whitespace and newlines from the read strings. readf() takes a format string (to tell it how to read stuff)
 *        and a reference parameter to store the variable. it is used wheverywhere readln() doesn't make sense.
 * - ~= is the operator to append values to arrays. I use it a lot.
 * - Basically everything else you see is going to be similar to java or C++, but if you don't understand something, feel free to ask
*/


import std.stdio;
import std.string;

//For colors...
import consoled;

immutable float TAX = 0.08;

int main()
{
    shell();
    return 0;
}

void shell()
{
    char[] command;
    auto register = new CashRegister();
    writecln(Fg.lightBlue, "Welcome to RegisterShell! Type \"help\" for a list of available commands.");
    while(command != "quit")
    {
        //Write Prompt with colors
        fontStyle = FontStyle.bold;
        foreground = Color.green;
        writec(">$ ");
        fontStyle = FontStyle.none;
        resetColors();
        
        readln(command);
        command = strip(command);
        register.parseCommand(command);
    }
}

class CashRegister
{
    private Item[] purchases;
    private Item[] returns;
    
    private double dues = 0;
    private double moneyRegister = 100;
    
    //For purchases
    double ptotal = 0;
    double ptax = 0;
    
    double rtotal = 0;
    double rtax = 0;
    
    
    void parseCommand(char[] com)
    {
        char[] name;
        double cost;
        
        if (com == "quit")
        {
            return;
        }
        else if (com == "help")
        {
            this.printHelp();
            return;
        }
        else if (com == "addItem")
        {
            write("Item name > ");
            readln(name);
            name = strip(name);
            write("Item cost > ");
            readf(" %s", &cost);
            //Hackey so we don't get two prompts because of readf
            readln();
            this.addPurchase(name, cost);
            return;
        }
        else if (com == "purchase")
        {
            this.printBill(this.purchases, &ptotal, &ptax);
            this.purchase();
            if(this.moneyRegister > 0)
                this.purchases = [];
            else
                writecln(Fg.red, "Add more money to the register and try again");
                resetColors();
            return;
        }
        else if (com == "addReturn")
        {
            write("Item name > ");
            readln(name);
            name = strip(name);
            write("Item cost > ");
            readf(" %s", &cost);
            readln();
            this.addReturn(name, cost);
            return;
        }
        else if (com == "return")
        {
            this.printBill(this.returns, &rtotal, &rtax);
            this.eturnra();
            if(this.moneyRegister > 0)
                this.returns = [];
            else
                writecln(Fg.red, "Add more money to the register and try again");
                resetColors();
            return;
        }
        else if (com == "closeOut")
        {
            this.closeOut();
            return;
        }
        else if(com == "addMoney")
        {
            write("Amount > ");
            readf(" %s", &cost);
            readln();
            this.addRegisterMoney(cost);
        }
        else if (com == "")
        {
            //You can just press enter to get a new prompt
        }
        else
        {
            writeln("Unrecognized Command");
            return;
        }
    }
    
    void printHelp()
    {
        writeln("Available commands include:");
        writeln("quit");
        writeln("\tExit the RegisterShell");
        writeln("help");
        writeln("\tPrint this help");
        writeln("addItem [item name] [item cost]");
        writeln("\tAdd an item to the register");
        writeln("purchase");
        writeln("\tDeal with total purchase and clear the register");
        writeln("addReturn [item name] [item cost]");
        writeln("\tAdd an item to the returns register");
        writeln("return");
        writeln("\tDeal with total returns and clear the returns register");
        writeln("addMoney");
        writeln("\tAdd a specified amount to the register");
        writeln("closeOut");
        writeln("\tDisplay register stats and completely wipe the register");
    }
    
    void addPurchase(char[] name, double cost)
    {
        this.purchases ~= new Item(name, cost);
    }
    
    void addReturn(char[] name, double cost)
    {
        this.returns ~= new Item(name, cost);
    }
    
    //Passing in two pointers here, no elegant but it works
    void printBill(Item[] objects, double *total, double *tax)
    {
        writeln("Receipt:");
        foreach(item; objects)
        {
            writeln("\t", item.name, ": $", item.cost);
            *total += item.cost;
            *tax += item.tax;
        }
    }
    
    void purchase()
    {
        writeln("Subtotal = ", this.ptotal);
        writeln("Tax = ", this.ptax);
        writeln("Total = ", this.ptotal + this.ptax);
        this.dues = this.ptotal + this.ptax;
        this.levelDues();
    }
    
    void levelDues()
    {
        double paid = 0;
        double changeDue = 0;
        write("Cash Paid > ");
        readf(" %s", &paid);
        readln();
        this.moneyRegister += paid;
        changeDue = paid - this.dues;
        
        writeln("Change Due: $", changeDue);
        if(this.moneyRegister > 0)
            this.moneyRegister -= changeDue;
        
        this.ptotal = 0;
        this.ptax = 0;
    }
    
    //Return in pig latin, get it?
    void eturnra()
    {
        writeln("Item Total = ", this.rtotal);
        writeln("Tax = ", this.rtax);
        writeln("Total Refund = ", this.rtotal + this.rtax);
        if(this.moneyRegister > 0)
            this.moneyRegister -= this.rtotal + this.rtax;
        
        this.rtotal = 0;
        this.rtax = 0;
    }
    
    void addRegisterMoney(double amount)
    {
        this.moneyRegister += amount;
    }
    
    void closeOut()
    {
        writeln("Starting Money = 100");
        writeln("Ending Money = ", this.moneyRegister);
        this.moneyRegister = 100;
        writeln("Register Reset");
    }
}

class Item
{
    public char[] name;
    public double cost;
    public double tax;
    
    this(char[] name, double cost)
    {
        this.name = name;
        this.cost = cost;
        this.tax = cost * TAX;
    }
}
