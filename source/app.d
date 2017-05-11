import std.stdio;
import std.string;

immutable float TAX = 0.08;


int main()
{
    shell();
    return 0;
}

void shell()
{
    char[] command;
    writeln("Welcome to RegisterShell! Type \"help\" for a list of available commands.");
    while(command != "quit")
    {
        write(">$ ");
        readln(command);
        command = strip(command);
        parseCommand(command);
    }
}

void parseCommand(char[] com)
{
	static auto register = new CashRegister();
    if (com == "quit")
    {
        return;
    }
    else if (com == "help")
    {
        printHelp();
        return;
    }
    else if (com == "addItem")
    {
        return;
    }
    else if (com == "displayPurchase")
    {
        return;
    }
    else if (com == "addReturn")
    {
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
    else
    {
        writeln("Unrecognized Command");
        return;
    }
}

class CashRegister
{
    
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
