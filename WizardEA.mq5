// WizardEA.mq5
// A professional MetaTrader 5 Expert Advisor implementing a Moving Average Crossover strategy.

input int fastMA_Period = 9; // Fast Moving Average Period
input int slowMA_Period = 21; // Slow Moving Average Period
input double riskPercentage = 1.0; // Risk Percentage for Position Size

double FastMA, SlowMA;

void OnStart() {
    // Calculate Moving Averages
    FastMA = iMA(NULL, 0, fastMA_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
    SlowMA = iMA(NULL, 0, slowMA_Period, 0, MODE_SMA, PRICE_CLOSE, 0);

    // Crossover Logic
    if (CheckCrossover()) {
        double lotSize = CalculateLotSize();
        // Execute buy/sell depending on the crossover
        if (FastMA > SlowMA) {
            OrderSend(Symbol(), OP_BUY, lotSize, Ask, 2, 0, 0, "Buy Order", 0, 0, clrGreen);
        } else if (FastMA < SlowMA) {
            OrderSend(Symbol(), OP_SELL, lotSize, Bid, 2, 0, 0, "Sell Order", 0, 0, clrRed);
        }
    }
}

bool CheckCrossover() {
    // Logic to check for MA Crossover
    double lastFastMA = iMA(NULL, 0, fastMA_Period, 0, MODE_SMA, PRICE_CLOSE, 1);
    double lastSlowMA = iMA(NULL, 0, slowMA_Period, 0, MODE_SMA, PRICE_CLOSE, 1);
    return (lastFastMA < lastSlowMA && FastMA > SlowMA) || (lastFastMA > lastSlowMA && FastMA < SlowMA);
}

double CalculateLotSize() {
    double accountRisk = AccountBalance() * riskPercentage / 100;
    double lotSize = accountRisk / (100 * Point); // Example calculation
    return NormalizeDouble(lotSize, 2);
}