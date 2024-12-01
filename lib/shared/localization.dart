import 'package:flutter/cupertino.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      //Keys for WishlistScreen
      'noWishlistItems': 'No Wishlist Items',

      // Keys for MoreScreen
      'wishList': 'Wishlist',
      'storeLocations': 'Our Stores',

      // Keys for SettingsScreen
      'settings': 'Settings',
      'currentLanguage': 'Current Language',
      'switchLanguage': 'Switch to',
      'switchDarkLightModeText': 'Light/Dark mode',
      'english': 'English',
      'arabic': 'Arabic',

      // Keys for MainScreen
      'allChannels' : 'All Channels',
      'myChannels' : 'My Channels',
      'profile': 'Profile',
      'signIn': 'Sign In',
      'signOut': 'Sign Out',
      'more': 'More',

      // Keys for HomeScreen
      'searchProducts': 'Search For Products',
      'search': 'Search',
      'categories': 'Categories',

      // Keys for ProductCard
      'unknownProduct': 'Unknown Product',
      'currency': 'EGP',

      // Keys for ProductScroll
      'noProductsFound': 'No products found.',

      // Keys for HomeTitles
      'seeAll': 'See All',

      // Keys for MyCartScreen
      'quantity': 'Quantity',
      'price': 'Price',
      'totalCartPrice': 'Total Price',
      'deliveryFees': 'Your delivery fees will be calculated later',

      // Keys for CategoryProductsScreen
      'errorLoadingProducts': 'Error loading products.',

      // Keys for PaymentOptionsScreen
      'placeOrder': 'Place Order',
      'cashOnDelivery': 'Cash On Delivery',
      'choosePaymentMethod': 'Choose Payment Method',
      'deliveryCost': 'Delivery Fees',
      'priceSummary': 'Price Summary',
      'cartSummary': 'Order Details',
      'paymentOptions': 'Payment Options',
      'payWithVisa': 'Pay with Visa',
      'payWithCash': 'Pay with Cash',
      'orderPlaceSuccessMsg': 'Order placed successfully.',
      'inSufficientStock':
      'Unable to complete order due to insufficient stock.',
      'haveCoupon': 'Do you have a coupon?',
      'enterCouponCode': "Enter coupon code",
      'discount': 'Discount',
      'apply': 'Apply',
      'couponAppliedSuccess': 'Coupon applied successfully!',
      'invalidCouponCode': 'Invalid coupon code',
      'couponExpired': 'Coupon code expired',
      'couponLimitReached':
      'You have reached the usage limit of the coupon code',
      'appliedCoupons': 'Applied coupons',
      'couponCode': 'Coupon code',
      'insufficientTotalPrice':
      'Coupon can not be applied due to insufficient order total price',

      // Keys for LoginScreen
      'userNotFound': 'This email is not registered, please sign up first.',
      'wrongPassword': 'The password entered is incorrect, please try again.',
      'loginTitle': 'Sign in',
      'phoneNumberLabel': 'Phone Number',
      'signInButton': 'Sign in',
      'phoneVerificationError': 'An error occurred during phone verification.',
      'signInError': 'Failed to sign in with phone number.',
      'verificationFailedError': 'Verification failed: ',
      'signInSuccess': 'Signing in successful!',
      'signInRequest': 'Please, Sign in first',
      'phoneNumberNotRegistered':
      'This phone number is not registered please sign up first.',
      'phoneNumberRequired': 'Phone number is required',
      'phoneNumberNotValid': 'Enter a valid phone number (e.g., 01234567890)',
      'validateNotEmpty': 'This field can not be empty.',

      // Keys for OrdersScreen
      'ordersTitle': 'Orders',
      'noOrdersFound': 'No orders found',
      'paymentType': 'Payment type',
      'total': 'Total',
      'errorLoadingOrders': 'Error loading orders',

      // Keys for ProfileScreen
      'name': 'Name',
      'address': 'Address',
      'apartmentNumberProfile': 'Apartment #',
      'floorNumberProfile': 'Floor #',
      'buildingNumberProfile': 'Building #',
      'belovedDates': 'Beloved Dates',
      'points': 'Points',
      'updateProfile': 'Update Profile',
      'validAddressArabic':
      'Please write a valid address and try to write it in Arabic',
      'profileUpdated': 'Profile updated successfully!',
      'deleteAccount': 'Delete Account',
      'deleteSuccessMsg': 'Account deleted successfully',
      'deleteConfirm': 'Confirm Delete',
      'deleteConfirmMsg':
      'Are you sure you want to delete your account? This action cannot be undone.',
      'deleteErrorMsg': 'Something went wrong. Please try again later.',
      'delete': 'Delete',
      'cancel': 'Cancel',

      // Keys for SignupScreen
      'password': "Password",
      'passwordRequired': 'Password is required.',
      'passwordLength': 'Password must be between 8 and 20 characters.',
      'passwordNotValid':
      'Password must contain at least one letter and one number.',
      'addBelovedDatesError': "Sorry, you can't add more than 3 dates.",
      'email': 'Email',
      'lastName': 'Last Name',
      'firstName': 'First Name',
      'signup': 'Sign up',
      'addDateInfo':
      'Add important dates that you want to remember, like your wedding day or first child\'s birthday.',
      'dateToRemember': 'Date to Remember',
      'selectDate': 'Select a date',
      'addDate': 'Add Date',
      'maxDatesError': 'Sorry, you can\'t add more than 3 dates.',
      'signinRedirectStatement': 'Already have an account? ',
      'signinRedirect': 'Sign in.',
      'signupButton': 'Sign up',
      'invalidPhoneNumber': 'Invalid phone number',
      'verificationFailed': 'Verification failed',
      'signupSuccess': 'Signup successful!',
      'signupFailed': 'Signup failed',
      'phoneNumberAlreadyRegistered':
      'This phone number is already registered please try again with another number.',
      'emailAlreadyRegistered':
      'This email is already registered please try again with another email.',
      'emailRequired': 'Email is required.',
      'emailNotValid': 'Enter a valid email address',

      // Keys for MoreScreen
      'logOut': 'Log out'
    },
    'ar': {

      //Keys for WishlistScreen
      'noWishlistItems': 'لا توجد منتجات مفضلة',

      // Keys for MoreScreen
      'wishList': 'قائمة التفضيلات',
      'storeLocations': 'فروعنا',

      // Keys for SettingsScreen
      'settings': 'الإعدادات',
      'currentLanguage': 'اللغة الحالية',
      'switchLanguage': 'التبديل إلى',
      'switchDarkLightModeText': 'تبديل الوضع المظلم والمضئ',
      'english': 'الإنجليزية',
      'arabic': 'العربية',

      // Keys for MainScreen
      'allChannels' : 'جميع القنوات',
      'myChannels' : 'قنواتي',
      'profile': 'الملف الشخصي',
      'more': 'المزيد',
      'signIn': 'تسجيل الدخول',
      'signOut': 'تسجيل الخروج',

      // Keys for HomeScreen
      'searchProducts': 'البحث عن منتجات',
      'search': 'البحث',
      'categories': 'الفئات',

      // Keys for ProductCard
      'unknownProduct': 'منتج مجهول',
      'currency': 'جنيه',

      // Keys for ProductScroll
      'noProductsFound': 'لا يوجد منتجات.',

      // Keys for HomeTitles
      'seeAll': 'عرض الكل',

      // Keys for MyCartScreen
      'quantity': 'الكمية',
      'price': 'السعر',
      'totalCartPrice': 'الإجمالي',
      'deliveryFees': 'سيتم احتساب رسوم التوصيل الخاصة بك لاحقا',

      // Keys for CategoriesScreen
      'turkish': 'تركي',

      // Keys for CategoryProductsScreen
      'errorLoadingProducts': 'حدث خطأ أثناء تحميل المنتجات.',

      // Keys for PaymentOptionsScreen
      'placeOrder': 'إتمام الطلب',
      'cashOnDelivery': 'الدفع عند التوصيل',
      'choosePaymentMethod': 'إختر طريقة الدفع',
      'deliveryCost': 'سعر التوصيل',
      'priceSummary': 'ملخص الدفع',
      'cartSummary': 'تفاصيل الطلب',
      'paymentOptions': 'خيارات الدفع',
      'payWithVisa': 'الدفع بواسطة فيزا',
      'payWithCash': 'الدفع نقدًا',
      'orderPlaceSuccessMsg': 'تم تسجيل الطلب بنجاح.',
      'inSufficientStock':
      'لم نتمكن من إتمام الطلب بسبب نقص في الكميات المتاحة.',
      'haveCoupon': 'هل تملك كود خصم؟',
      'enterCouponCode': "أدخل كود الخصم",
      'discount': 'الخصم',
      'apply': 'تطبيق',
      'couponAppliedSuccess': 'تم تطبيق الخصم بنجاح!',
      'invalidCouponCode': 'كود الخصم غير صالح',
      'couponExpired': 'كود الخصم منتهي الصلاحية',
      'couponLimitReached': 'وصلت الحد الأقصي من الإستخدامات لكود الخصم',
      'appliedCoupons': 'أكواد الخصم المستخدمة',
      'couponCode': 'كود الخصم',
      'insufficientTotalPrice':
      'لا يمكن تطبيق كود الخصم بسبب السعر الكلي للطلب',

      // Keys for LoginScreen
      'userNotFound':
      'هذا البريد الإلكتروني غير مسجل لدينا، يرجى إنشاء حساب جديد.',
      'wrongPassword': 'كلمة المرور المدخلة غير صحيحة، يرجى المحاولة مرة أخرى.',
      'loginTitle': 'تسجيل الدخول',
      'phoneNumberLabel': 'رقم الهاتف',
      'phoneNumberHint': '01234567890',
      'signInButton': 'تسجيل الدخول',
      'phoneVerificationError': 'حدث خطأ أثناء التحقق من الهاتف.',
      'signInError': 'فشل تسجيل الدخول برقم الهاتف.',
      'verificationFailedError': 'فشل التحقق: ',
      'signInSuccess': 'تم تسجيل الدخول بنجاح!',
      'signInRequest': 'سجل الدخول أولا',
      'phoneNumberNotRegistered':
      'هذا الرقم غير مسجل لدينا يرجى تسجيل حساب جديد اولا.',
      'phoneNumberRequired': 'رقم الهاتف مطلوب.',
      'phoneNumberNotValid': 'برجاء إدخال رقم هاتف صحيح (مثل 01234567890)',
      'validateNotEmpty': 'هذا الحقل لا يمكن أن يكون فارغا.',

      // Keys for OrdersScreen
      'ordersTitle': 'الطلبات',
      'noOrdersFound': 'لا يوجد طلبات',
      'paymentType': 'نوع الدفع',
      'total': 'المجموع',
      'errorLoadingOrders': 'خطأ في تحميل الطلبات',

      // Keys for ProfileScreen
      'name': 'الاسم',
      'address': 'العنوان',
      'apartmentNumberProfile': 'رقم الشقة',
      'floorNumberProfile': 'رقم الطابق',
      'buildingNumberProfile': 'رقم المبنى',
      'belovedDates': 'التواريخ المهمة',
      'points': 'النقاط',
      'updateProfile': 'تحديث الملف الشخصي',
      'validAddressArabic':
      'يرجى كتابة عنوان صحيح ومحاولة كتابته باللغة العربية',
      'profileUpdated': 'تم تحديث الملف الشخصي بنجاح!',
      'deleteAccount': "حذف الحساب",
      'deleteSuccessMsg': 'تم حذف الحساب بنجاح.',
      'deleteConfirm': 'تأكيد الحذف',
      'deleteConfirmMsg':
      'هل انت متأكد من حذف حسابك؟ لا يمكن إلغاء هذا القرار.',
      'deleteErrorMsg': 'حدث خطأ. برجاء المحاولة مرة أخرى.',
      'delete': 'حذف',
      'cancel': 'إلغاء',

      // Keys for SignupScreen
      'password': "كلمةالمرور",
      'passwordRequired': 'كلمة المرور مطلوبة.',
      'passwordLength': 'يجب أن تكون كلمة المرور بين 8 و 20 حرفًا.',
      'passwordNotValid':
      'يجب أن تحتوي كلمة المرور على حرف واحد على الأقل ورقم واحد.',
      'addBelovedDatesError': 'عفواً لا يمكن إضافة أكثر من 3 تواريخ.',
      'email': 'البريد الإلكتروني',
      'lastName': 'الإسم الأخير',
      'firstName': 'الإسم الأول',
      'signup': 'تسجيل جديد',
      'addDateInfo':
      'أضف التواريخ المهمة التي تريد تذكرها، مثل يوم زفافك أو عيد ميلاد طفلك الأول.',
      'dateToRemember': 'تاريخ لتذكره',
      'selectDate': 'اختر تاريخ',
      'addDate': 'إضافة تاريخ',
      'maxDatesError': 'عذرًا، لا يمكنك إضافة أكثر من 3 تواريخ.',
      'signinRedirectStatement': ' هل لديك حساب بالفعل؟',
      'signinRedirect': 'تسجيل الدخول.',
      'signupButton': 'تسجيل جديد',
      'invalidPhoneNumber': 'رقم الهاتف غير صالح',
      'verificationFailed': 'فشل التحقق يرجى إعادة المحاولة مرة أخرى.',
      'signupSuccess': 'تم التسجيل بنجاح!',
      'signupFailed': 'فشل التسجيل',
      'phoneNumberAlreadyRegistered':
      'هذا الرقم مسجل مسبقا يرجى المحاولة برقم أخر.',
      'emailAlreadyRegistered':
      'هذا البريد مسجل مسبقا يرجي المحاولة بإستخدام بريد أخر.',
      'emailRequired': 'الإيميل الشخصي مطلوب.',
      'emailNotValid': 'الإيميل الشخصي غير صحيح.',

      // Keys for MoreScreen
      'logOut': 'تسجيل خروج'
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]![key] ?? '';
  }
}
