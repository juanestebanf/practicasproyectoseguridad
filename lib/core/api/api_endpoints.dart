class ApiEndpoints {
  
  static const String baseUrl = 'https://practicasproyectoseguridad-2.onrender.com'; 
  
  // Perfil
  static const String profile = '/users/profile';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String checkEmail = '/auth/check-email';
  static const String checkCedula = '/auth/check-cedula';
  
  // Alerts
  static const String alerts = '/alerts';
  static const String alertHistory = '/alerts/history';
  static const String assignedAlerts = '/alerts/assigned';
  static const String activeAlerts = '/alerts/active';
  static const String pendingApproval = '/alerts/pending-approval';
  static const String myStats = '/alerts/my-stats';
  
  // Contacts
  static const String contacts = '/contacts';
  
  // Authorities
  static const String authorities = '/authorities';
}
