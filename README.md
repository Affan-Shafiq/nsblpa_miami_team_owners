# Miami Revenue Runners - Team Ownership App

A comprehensive Flutter application for managing team ownership, revenue tracking, contracts, and compliance for the Miami Revenue Runners basketball team.

## 🏀 Features

### 📊 Ownership Dashboard
- **Ownership Metrics**: View your ownership percentage, total investment, and current value
- **ROI Tracking**: Monitor your return on investment with real-time calculations
- **Team Performance**: Overview of team value, revenue, and profit margins
- **Quick Actions**: Easy access to key features and recent activity

### 💰 Revenue Report
- **Season-wise Revenue**: Track revenue across multiple seasons
- **Revenue Breakdown**: Detailed analysis of ticket sales, merchandise, and advertising
- **Interactive Charts**: Visual representation of revenue trends using FL Chart
- **Performance Metrics**: Compare revenue across different seasons

### 📋 Team Contracts
- **Player & Staff Management**: Comprehensive contract tracking for all team members
- **Contract Status**: Monitor active, expired, and pending contracts
- **Filtering Options**: Filter by type (players/staff) and status
- **Contract Details**: View salary, duration, and key dates
- **Digital Signing**: Integration ready for digital contract signing

### 💬 Communication Tools
- **Team Announcements**: Create and manage team-wide announcements
- **Internal Updates**: Share performance alerts and team updates
- **Message System**: Internal communication platform for team members
- **Announcement Types**: Categorize by events, news, and updates

### ⚖️ Compliance & Legal
- **Document Management**: Upload and organize IRS documents, state filings
- **Policy Updates**: Track NSBLPA ownership policy changes
- **Digital Signing**: Secure digital signature integration
- **Status Tracking**: Monitor document approval and review status

## 🎨 Design & Branding

### Miami Revenue Runners Theme
- **Primary Color**: Miami Blue (#00A3E0)
- **Secondary Color**: Miami Orange (#FF6B35)
- **Accent Color**: Deep Blue (#1E3A8A)
- **Modern UI**: Material Design 3 with custom theming
- **Responsive Design**: Optimized for mobile and tablet devices

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nsblpa_miami_team_owners
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials
- **Email**: demo@miamirevenuerunners.com
- **Password**: demo123

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── revenue_model.dart
│   └── contract_model.dart
├── screens/                  # UI screens
│   ├── auth/                 # Authentication
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   └── dashboard/            # Main app screens
│       ├── dashboard_screen.dart
│       └── widgets/          # Dashboard components
│           ├── ownership_dashboard.dart
│           ├── revenue_report.dart
│           ├── team_contracts.dart
│           ├── communication_tools.dart
│           └── compliance_legal.dart
├── services/                 # Data services
│   └── dummy_data_service.dart
└── utils/                    # Utilities
    └── theme.dart           # App theming
```

## 🛠️ Dependencies

- **fl_chart**: Interactive charts and graphs
- **google_fonts**: Custom typography
- **intl**: Internationalization and formatting
- **flutter_svg**: SVG image support
- **shared_preferences**: Local data storage

## 🔧 Configuration

### Firebase Integration (Future)
The app is designed to integrate with Firebase for:
- User authentication
- Real-time data synchronization
- Cloud storage for documents
- Push notifications

### Customization
To customize for other teams:
1. Update branding colors in `lib/utils/theme.dart`
2. Modify team name and logo assets
3. Update dummy data in `lib/services/dummy_data_service.dart`
4. Adjust navigation and routing as needed

## 📊 Data Models

### User Model
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double ownershipPercentage;
  final double totalInvestment;
  final String teamId;
}
```

### Revenue Model
```dart
class RevenueData {
  final String id;
  final String season;
  final double ticketSales;
  final double merchandise;
  final double advertising;
  final double totalRevenue;
  final DateTime date;
}
```

### Contract Model
```dart
class Contract {
  final String id;
  final String name;
  final String type; // 'player' or 'staff'
  final String position;
  final double salary;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'expired', 'pending'
  final String? documentUrl;
}
```

## 🎯 Key Features Implementation

### Authentication
- Email/password login and signup
- Form validation and error handling
- Demo credentials for testing
- Secure password requirements

### Dashboard Navigation
- Bottom navigation with 5 main sections
- Tab-based navigation within sections
- Responsive design for different screen sizes

### Data Visualization
- Line charts for revenue trends
- Progress indicators for ownership metrics
- Status badges for contracts and documents
- Color-coded categories and statuses

### User Experience
- Loading states and animations
- Error handling and empty states
- Intuitive navigation and interactions
- Modern Material Design components

## 🔮 Future Enhancements

### Planned Features
- **Real-time Notifications**: Push notifications for important updates
- **File Upload**: Document upload and management
- **Digital Signing**: Integration with e-signature services
- **Analytics Dashboard**: Advanced reporting and insights
- **Multi-language Support**: Internationalization
- **Offline Support**: Offline data synchronization

### Technical Improvements
- **State Management**: Implement Riverpod or Bloc
- **API Integration**: Connect to backend services
- **Testing**: Unit and widget tests
- **Performance**: Optimize for large datasets
- **Security**: Enhanced authentication and data protection

## 📄 License

This project is proprietary software developed for the NSBLPA Miami Revenue Runners team.

## 🤝 Contributing

For internal development and contributions, please follow the established coding standards and review process.

## 📞 Support

For technical support or questions about the app, please contact the development team.

---

**Miami Revenue Runners** - Empowering team ownership through technology 🏀
# nsblpa_miami_team_owners
