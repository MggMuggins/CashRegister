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
import std.conv;

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
    writeln("Welcome to RegisterShell! Type \"help\" for a list of available commands.");
    while(command != "quit")
    {
        write(">$ ");
        readln(command);
        command = strip(command);
        register.parseCommand(command);
    }
}

class CashRegister
{
    private Item[] purchases;
    private Item[] returns;
    private double total = 0;
    private double moneyRegister = 100;
    
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
            write("Item cost > ");
            readf(" %s", &cost);
            this.addPurchase(name, cost);
            return;
        }
        else if (com == "displayPurchase")
        {
            this.printPurchases();
            return;
        }
        else if (com == "addReturn")
        {
            write("Item name > ");
            readln(name);
            write("Item cost > ");
            readf(" %s", &cost);
            this.addReturn(name, cost);
            return;
        }
        else if (com == "displayReturns")
        {
            return;
        }
        else if (com == "closeOut")
        {
            return;
        }
        else if (com == "")
        {
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
        writeln("displayPurchase");
        writeln("\tDisplay the total purchase and clear the register");
        writeln("addReturn [item name] [item cost]");
        writeln("\tAdd an item to the returns register");
        writeln("displayReturns");
        writeln("\tDisplay the total returns and clear the returns register");
        writeln("closeOut");
        writeln("\tDisplay register stats and completely wipe the register");
    }
    
    void addPurchase(char[] name, double cost)
    {
        this.purchases ~= new Item(name, cost);
    }
    
    void printPurchases()
    {
        foreach(item; this.purchases)
        {
            writeln("\t", item.name, ": $", item.cost);
        }
    }
    
    void addReturn(char[] name, double cost)
    {
        this.returns ~= new Item(name, cost);
    }
    
    void printReturns()
    {
        foreach(item; this.returns)
        {
            writeln("\t", item.name, ": $", item.cost);
        }
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
