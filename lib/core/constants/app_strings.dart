class AppStrings {
  // Navigation
  static const String navWatchlist = 'Watchlist';
  static const String navMarket = 'Market';
  static const String navPortfolio = 'Portfolio';

  // Market & Watchlist Screens
  static const String titleLiveMarket = 'Live Market';
  static const String titleWatchlist = 'Watchlist';
  static const String errorNoWatchlists =
      'No watchlists available. Create one!';
  static const String errorEmptyWatchlist =
      'Watchlist is empty. Add some stocks!';
  static const String colCompanyName = 'Company Name';
  static const String colVolumeCr = 'Volume (Cr)';
  static const String colVolume = 'Volume';
  static const String colLTP = 'LTP';

  // Dialogs
  static const String dialogNewWatchlist = 'New Watchlist';
  static const String dialogCancel = 'Cancel';
  static const String dialogAdd = 'Add';
  static const String dialogDelete = 'Delete';
  static const String dialogAddStock = 'Add Stock';
  static const String dialogAllStocksInWatchlist =
      'All stocks are already in the watchlist.';
  static const String dialogDeleteWatchlist = 'Delete Watchlist';
  static const String dialogDeleteWatchlistConfirm =
      'Are you sure you want to delete this watchlist?';
  static const String errorMaxWatchlistsReached =
      'Maximum limit of 10 watchlists reached.';
  static const String errorMinWatchlistRequired =
      'At least one watchlist is required.';

  // Portfolio Screen
  static const String titlePortfolio = 'Portfolio';
  static const String portfolioCurrentValue = 'Current Value';
  static const String portfolioInvested = 'Invested';
  static const String portfolioProfitLoss = 'Profit / Loss';
  static const String portfolio1DChange = '1D Change';
  static const String portfolioNoHoldings = 'No holdings yet. Buy some stocks!';

  // Portfolio Sorting & Filtering
  static const String sortPnl = 'Sort By P&L';
  static const String sortSymbol = 'Sort By Symbol';
  static const String sortValue = 'Sort By Value';
  static const String sortPrefix = 'Sort:';
  static const String sortLabelPnl = 'P&L';
  static const String sortLabelValue = 'Value';
  static const String sortLabelName = 'Name';
  static const String openOrders = 'Open Orders';

  // Portfolio List Headers & Rows
  static const String colNameQty = 'Name / Qty';
  static const String colValLtp = 'Val (LTP)';
  static const String colPnl1d = 'P&L (1D)';
  static const String labelQty = 'Qty:';
  static const String labelAvg = 'Avg:';
  static const String labelLtp = 'LTP:';

  // Buy/Sell Ticket Screen
  static const String tradePrefix = 'Trade';
  static const String currentPrice = 'Current Price:';
  static const String buttonBuy = 'Buy';
  static const String buttonSell = 'Sell';
  static const String inputQuantity = 'Quantity';
  static const String orderValue = 'Order Value:';
  static const String availableBalance = 'Available Balance';
  static const String maxBuyQty = 'Max Buy Quantity';
  static const String currentHolding = 'Current Holding';
  static const String maxSellQty = 'Max Sell Quantity';
  static const String errorInvalidQty = 'Please enter a valid quantity';
  static const String placeBuyOrder = 'Place Buy Order';
  static const String placeSellOrder = 'Place Sell Order';
  static const String qtySuffix = 'Qty';
}
