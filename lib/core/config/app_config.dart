class AppConfig {
  static const String appName = 'Trading App';

  // Market Mock Feed Config
  static const int tickIntervalMs = 500; // Debug setting for tick rate

  static const List<String> availableStocks = [
    'RELIANCE',
    'TCS',
    'INFY',
    'HDFCBANK',
    'ICICIBANK',
    'SBIN',
    'ITC',
    'LT',
    'BHARTIARTL',
    'AXISBANK',
  ];

  static const Map<String, String> companyNames = {
    'RELIANCE': 'Reliance Industries Ltd.',
    'TCS': 'Tata Consultancy Services',
    'INFY': 'Infosys Limited',
    'HDFCBANK': 'HDFC Bank Ltd.',
    'ICICIBANK': 'ICICI Bank Ltd.',
    'SBIN': 'State Bank of India',
    'ITC': 'ITC Limited',
    'LT': 'Larsen & Toubro Ltd.',
    'BHARTIARTL': 'Bharti Airtel Ltd.',
    'AXISBANK': 'Axis Bank Ltd.',
  };

  // Mock volumes for UI purposes (in Cr)
  static const Map<String, double> companyVolumes = {
    'RELIANCE': 38.73,
    'TCS': 25.79,
    'INFY': 6.17,
    'HDFCBANK': 5.67,
    'ICICIBANK': 5.05,
    'SBIN': 4.75,
    'ITC': 4.68,
    'LT': 12.01,
    'BHARTIARTL': 8.90,
    'AXISBANK': 10.45,
  };

  static const double initialWalletBalance = 100000.0;
}
