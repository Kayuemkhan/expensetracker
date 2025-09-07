import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcomeTitle': 'Welcome to xFunding',
          'welcomeDescription' : 'A Helping Hand For A Hoping Heart',
          'selectYourLanguage': 'Select Your Language',
          'signIn': 'Sign IN',
          'signUp': 'Sign Up',
          'next': 'NEXT',
          'getStarted': 'GET STARTED',
          'skip': 'Skip',
          'conTinue': 'Continue',
          'search': 'Search',
          'cancel': 'Cancel',
          'submit': 'Submit',
          'okay': 'Okay',
          'proceed': "Proceed",
          'confirm': "Confirm",
          'viewProfile': "View Profile",
          'deposit': "Deposit",
          'signOut': "SignOut",
          'saveChange': "Save Change",
          'updateProfile': "Update Profile",
          'enable': "Enable",
          'onboardTitle1': 'Share Kindness Easily Now',
          'onboardTitle2': 'Meaningful Donation',
          'onboardTitle3': 'Accurate Fundraising',
          'onboardDescription1':
              'Now sharing kindness can be quickly and easily with just one touch',
          'onboardDescription2':
              'Any donation from you will really be able to help others',
          'onboardDescription3':
              'The fundraising made has gone through the verification process',
          'termsAndPolicy': 'By using this App you agree to ours ',
          'termsAndService': ' Terms of Service',
          'and': ' and',
          'privacyPolicy': ' Privacy & Policy',
          'signInTitle': 'Welcome Back',
          'signInDescription': 'A Helping Hand For A Hoping Heart',
          'userName': 'User Name',
          'password': 'Password',
          'forgetPass': "Forgot Password?",
          'donTHaveAccount': "Don't have an Account? ",
          'forgotPassword': "Forgot Password",
          'forgotPasswordDescription':
              "Please Enter Your Email Address to Reset Your Password",
          'email': "Email",
          'otpVerification': "OTP Verification",
          'otpVerificationTitle': "Enter the code sent to",
          'otpVerificationDescription': "admin.username@email.com",
          'didNTGetAnyCode': "Didn't get any code? ",
          'resend': "Resend",
          'time': "00:59",
          'resetPassword': "Reset Password",
          'resetPasswordTitle':
              "You identity has been verified,\n Set your new Password",
          'newPassword': "New Password",
          'confirmNewPassword': "Confirm New Password",
          'congratulations': "Congratulations",
          'congratulationsDescription':
              "Your password has been successfully changed",

          //? email verification screen
          'emailVerification': "Email Verification",

          //? sign up screen
          'phoneNumber': "P:hone Number",
          'country': "Co'untry",
          'city': "City",
          'state': "State",
          'street': "Street",
          'code': "Zip Code",
          'alreadyHaveAnAccount': "Already have an account? ",
          'signUpTitle': "Create an Account",
          'signUpDescription': "A Helping Hand For A Hoping Heart",
          'selectCountry': 'Select Country',
          'firstName': 'First Name',
          'lastName': 'Last Name',
          'enterPhoneNumber': "Enter Phone Number",

          //? notification screen
          'notification': "Notification",
          'donateForEducation': "Donate for Education Development",
          'date': "March 22, 2022",

          //?home screen
          'categories': "Categories",
          'church': "Church",
          'disaster': "Disaster",
          'urgentFundraising': "Urgent Fundraising",
          'sellAll': "Sell All",
          'donateNow': "Donate Now",
          'viewAll': "View All",
          'shareNutritiousFood': "Share Nutritious Food",
          'shareNutritiousFoodMoney': "\$709836.00",
          'shareNutritiousFoodLeftDays': "27 Days Left",
          'shareNutritiousFoodDonatedPercentage': "70% Donated",
          'goal': "Goal: ",
          'shareNutritiousFoodMoneyGoal': "\$10000000.00",
          'popularFundraiser': "Popular Fundraiser",
          'topVolunteer': "Top Volunteer",
          'donationKiosks': "Donation Kiosks",
          'nigerianFoundation': "Nigerian Foundation",
          'funeral': "Funeral",

          //? donate now screen
          'description': "Description",

          'msgDonatePreview': "We are committed towards providing education "
              "to every single child in India. Donate for the education of poor children and give them the gift of education.",
          'descriptionDetailsOne':
              "Equipped with  literacy and essential life skills, they can grow into adults  who earn"
                  " higher wages , educate  their own  children , and have a voice in their community. You'll help kids break the cycle "
                  "of poverty by providing resources like: Teaching and ",
          'descriptionDetailsTwo':
              "Equipped with  literacy and essential life skills, they can grow into adults  who earn higher "
                  "wages , educate  their own  children , and have a voice in their community. You'll help kids break the cycle "
                  "of poverty by providing resources like: Teaching and learning materi-als in local languages . Equip-ped with "
                  " literacy and essential life skills, they can grow into adults  who earn higher wages , educate  their own  "
                  "child-ren , and have a voice in their commu-nity . You'll help kids break the cycle of poverty by providing"
                  " resources like: Teaching and learning materi-als in local languages.",

          //? donate screen:
          'donate': "Donate",
          'education': "Education",
          'amount': "Amount",
          'paymentGateway': "Payment GateWay Selection",
          'payment': "Payment",
          'yourGoal': "Your Goal",
          'amountMoney': "0.00",
          'message': "Message",
          'optional': "Optional",
          'paymentMethod': "Payment Method",
          'myWallet': "My Wallet",
          'carNumber': "**** **** **** 9683",
          'addCard': "+Add Card",
          'donateForEdu': "Donate for Education Development",
          'from': "From",
          'to': "To",
          'usd': "USD",

          //? payment method screen
          "charge": "Charge",
          "processingTime": "Processing Time",
          "chargeAmount": "2.00 USD + 3%",
          "processingTimeAmount": "1 - 2 Hours",

          //? donate review screen
          "review": "Review",
          "foundation": "Foundation",
          "foundationName": "Peer-to-Peer Fundraising",
          "foundationAmount": "\$50.00",

          //? donate success screen
          "success": "Success!",
          "successSubTitle": "Thank you for donating",
          "successDes":
              "Your donation means a lot to them and helps make the world a better place.",

          //? medical screen
          "medical": "Medical",
          "nigerianMedicalDev": "Nigerian Medical Dev",
          "searchCampaign": "Search Campaign",
          "searchVolunteer": "Search Volunteer",

          //? popular fundraiser screen
          "americanFounding": "American Founding",

          //? Donation kiosks screen
          "recentActivities": "Recent Activities",
          "accomplishedCampaign": "Accomplished Campaign",
          "campaignDuration": "Campaign Duration: ",
          "days": '' "Days",
          'totalDays': "90",
          'reach': "Reach : \$",
          'reachMoney': "9805686.00",

          //? create campaign screen
          'selectCategories': "Select Categories",
          'createCampaign': "Create Campaign",
          'title': "Title",
          'writeHere': "Write here",
          'writeYourDescriptionForFundRise':
              "Write your Description for Fundrise",
          'image': "Image",
          'attachDocument': "Attach Document (Pdf)",
          'targetAmount': "TargetAmount",
          'campaignGoal': "Campaign Goal",
          'dueDate': "Due Date",
          'deadline': "Deadline",
          'dMy': "DD/MM/YYYY",
          'location': "Location",

          //?wait for approval screen
          'waitForApprovalTitle': "Wait For Approval",
          'waitForApprovalDes': "Wait a while for verification in admin panel.",

          //? profile screen
          'profileName': "Ledienson Arker",
          'profile': "Profile",
          'profileOrg': "Nigerian Organizer",
          'currentBalance': "Current Balance",
          'recentDeposit': "Recent Deposit",
          'recentWithdraw': "Recent Withdraw",
          'recentDepositMoney': "\$ 1000.00",
          'recentWithdrawMoney': "\$ 1000.00",
          'currentBalanceMoney': "\$ 106689.00",
          'myCampaign': "My Campaign",
          'withdraw': "Withdraw",
          'withdrawAmount': "Withdraw Amount",

          //? deposit amount
          'paypal': "Paypal",
          'stripe': "Stripe",
          'depositAmount': "Deposit Amount",

          //? drawer screen
          'editProfile': "Edit Profile",
          'allCampaign': "All Campaign",
          'myCards': "My Cards",
          'myCampaigns': "My Campaigns",
          'myDonations': "My Donations",
          'depositLog': "Deposit Log",
          'settings': "Settings",
          'withdrawLog': "Withdraw Log",
          'shareApp': "Share App",
          'helpCenter': "Help Center",
          'aboutUs': "About us",
          'rateUs': "Rate us",
          'changePassword': "Change Password",
          'changeLanguage': "Change Language",
          'faSecurity': "2FA Security",
          'createNewTicket': "Create New Ticket",
          'myTickets': "My Tickets",

          //? edit pro'file screen
          'editProfileEmail': "lediensonarker@gmail.com",
          'address': "Address",
          'editProfilePhoneNumber': "+1 659 659 6321",

          //?my cards screen
          "visaCard": "VISA Card",
          "visaCardNumber": "5689 5687 9867 2345",
          "expiryDate": "Expiry Date",
          "expiryDateToday": "12/2026",
          "cvc": "CVV/CVC",
          "cvcNumber": "635",
          "adDCard": "Add Card",

          //? Add card screen
          "selectCardType": "Select Card Type",
          "masterCard": "Mastercard",
          "cardDetails": "Card Details",
          "nameOfCard": "Name On Card",
          "cardNUmber": "Card Number",
          "mY": "MM/YY",

          //? my donations screen
          'myDonationsDollar': "\$50.00",

          //? change password screen
          'oldPassword': "Old Password",
          'neWPassword': "New Password",
          'confirmPassword': "Confirm Password",

          //? change language screen
          'arabic': "Arabic",
          'english': "English",
          'bangla': "Bangla",
          'german': "German",

          //? help center screen
          'qnOne': "How to Add Card in your profile?",
          'qnTwo': "How to Donate?",
          'qnThree': "How to Create Campaign?",
          'qnFour': "How to Share My Campaign in Social Media?",
          'qnFive': "How to Create Campaign?",

          //? live chat screen
          'liveChat': "Live Chat",
          'liveChatOneQn': "How can we help with xFunding?",
          'liveChatTwoQn': "How to I Donate?",
          'liveChatThreeQn':
              "First of all you need to add your Mastercard or Visa-card for payment source. Then you can Donate any Fundraiser.",
          'liveChatFourQn': "Thank you so much...",
          'composeYourMessage': "Compose your message.....",

          //? about screen
          'aboutUsPartOne':
              "Crafting a compelling job description is essential to helping you attract the most qualified candidates for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are wh",
          'aboutUsPartTwo':
              "Crafting a compelling job description is essential to helping you attract the most qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire Crafting a com pelling job description is essealtse most qualified candites for your job. With more than 25 million jobs listed Indeed, a great job description can help your jobs stan out from a rest. Your job descriptions are where you start your company and you job to your future hire.. Crafting a compelling job description is essential the mos qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire.",
          'aboutUsPartThree':
              "Crafting a compelling job description is essential to helping you attract the most qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire Crafting a com pelling job description is essealtse most qualified candites for your job. With more than 25 million jobs listed Indeed, a great job description can help your jobs stan out from a rest. Your job descriptions are where you start your company and you job to your future hire.. Crafting a compelling job description is essential the mos qualified candidates for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire. Crafting a cop qualified candidates for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire Crafting a compelling job description is essealtse most qualified candites for your job. With more than 25 million jobs listed Indeed, a great job description can help your jobs stan out from a rest. Your job descriptions are where you start your company and you job to your future hire.. Crafting a compelling job description is essential the mos qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire.",
          'aboutUsPartFour':
              "Crafting a compelling job description is essential to helping you attract the most qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire.",
          'copyright': "CopyRight © 2022 xFunding",
          'websiteLink': "www.xFunding.com",

          //? deposit method screen
          'depositMethod': "Deposit Method",
          'limit': "Limit",
          'limitMoney': "10.00 - 1000.00 USD",

          //? de'posit preview screen
          'depositPreview': "Deposit Preview",

          //? deposit success screen
          'successDesDeposit': "Your 100.00 USD Successfully Deposit.",

          //? withdraw method screen
          'withdrawMethod': "Withdraw Method",
          'trx': "TRX 2546RT56VSW89",
          'withdrawPreview': "Withdraw Preview",
          'successDesWithdraw': "Your 100.00 USD Successfully Withdraw.",
          'twoFactorAuthCode': "RSIK6ZDNDPVOIBVX",

          //? create new tickets
          'subject': "Subject",

          //? my tickets screen
          'myTicketTransaction': "TN-123456789",
          'hereIsTicketIssues': "Here is ticket issues....",
          'solved': "Solved",
          'pending': "Pending",
          'pendingCampaign': "Pending Campaign",
          'rejected': "Rejected",
          'rejectedCampaign': "Rejected Campaign",
          'successfulCampaign': "Successful Campaign",

          //? dashboard screen
          'dashboard': "Dashboard",
          'totalCampaign': "Total Campaign",
          'donationReport': "Monthly Donation Report",
          'withdrawReport': "Monthly Withdraw Report",

          //? filter
          'filterCampaign': "Filter Campaign",
          'filterByCategory': "Filter by Category",
          'filterByDate': "Filter by Date",

          //? success story screen
          'successStory': "Success Story",

          //? success story each screen
          'comments': "10 Comments",
          'leaveAComment': "Leave a Comment",
          'comment': "i'm thankful to them who donate money for child's",

          'views': "100 Views",
          'androidAppUrl':
              'https://play.google.com/store/apps/details?id:net.appdevs.xfundingnew',
          'iosAppUrl': '',
        },


        'ar_Arabic': {

          'welcomeTitle': 'مرحبا بك في',
          'welcomeDescription' : 'يد العون لقلب يأمل',
          'selectYourLanguage': 'اختر لغتك',
          'signIn': 'تسجيل الدخول',
          'signUp': 'اشتراك',
          'next': 'التالي',
          'getStarted': 'البدء',
          'skip': 'يتخطى',
          'conTinue': 'يكمل',
          'search': 'يبحث',
          'cancel': 'يلغي',
          'submit': 'يُقدِّم',
          'okay': 'تمام',
          'proceed': "يتابع",
          'confirm': "يتأكد",
          'viewProfile': "عرض الصفحة الشخصية",
          'deposit': "إيداع",
          'signOut': "خروج",
          'saveChange': "احفظ التغيير",
          'updateProfile': "تحديث الملف",
          'enable': "يُمكَِن",
          'onboardTitle1': 'شارك اللطف بسهولة الآن',
          'onboardTitle2': 'التبرع الهادف',
          'onboardTitle3': 'دقة جمع التبرعات',
          'onboardDescription1':
              'يمكن الآن مشاركة اللطف بسرعة وسهولة بلمسة واحدة فقط',
          'onboardDescription2':
              'أي تبرع منك سيكون حقًا قادرًا على مساعدة الآخرين',
          'onboardDescription3': 'لقد مرت عملية جمع الأموال بعملية التحقق',
          'termsAndPolicy': 'باستخدام هذا التطبيق ، فإنك توافق على تطبيقنا',
          'termsAndService': ' شروط الخدمة',
          'and': ' و',
          'privacyPolicy': ' سياسة الخصوصية',
          'signInTitle': 'مرحبًا بعودتك',
          'signInDescription': 'يد العون للقلب الأمل',
          'userName': 'اسم االمستخدم',
          'password': 'كلمة المرور',
          'forgetPass': "هل نسيت كلمة السر؟",
          'donTHaveAccount': "ليس لديك حساب؟ ",
          'forgotPassword': "هل نسيت كلمة السر",
          'forgotPasswordDescription':
              "الرجاء إدخال عنوان بريدك الإلكتروني لإعادة تعيين كلمة المرور الخاصة بك",
          'email': "البريد الإلكتروني",
          'otpVerification': "التحقق من OTP",
          'otpVerificationTitle': "أدخل الرمز المرسل إلى",
          'otpVerificationDescription': "admin.username@email.com",
          'didNTGetAnyCode': "لم تحصل على أي رمز؟ ",
          'resend': "إعادة إرسال",
          'time': "00:59",
          'resetPassword': "إعادة تعيين كلمة المرور",
          'resetPasswordTitle':
              "تم التحقق من هويتك ، \ n قم بتعيين كلمة المرور الجديدة",
          'newPassword': "كلمة السر الجديدة",
          'confirmNewPassword': "تأكيد كلمة المرور الجديدة",

          'congratulations': "تهانينا",
          'congratulationsDescription':
          "كلمة السر الخاصة بك تم تغييرها بنجاح",

          //? email verification screen
          'emailVerification': "تأكيد بواسطة البريد الالكتروني",

          //? sign up screen
          'phoneNumber': "رقم الهاتف",
          'country': "دولة",
          'city': "مدينة",
          'state': "حالة",
          'street': "شارع",
          'code': "الرمز البريدي",
          'alreadyHaveAnAccount': "هل لديك حساب؟ ",
          'signUpTitle': "انشئ حساب",
          'signUpDescription': "يد العون للقلب الأمل",
          'selectCountry': 'حدد الدولة',
          'firstName': 'الاسم الاول',
          'lastName': 'الكنية',
          'enterPhoneNumber': "أدخل رقم الهاتف",

          //? notification screen
          'notification': "تنبيه",
          'donateForEducation': "تبرع لتطوير التعليم",
          'date': "22 مارس 2022",

          //?home screen
          'categories': "فئات",
          'church': "فئات",
          'disaster': "كارثة",
          'urgentFundraising': "جمع التبرعات بشكل عاجل",
          'sellAll': "Sell All",
          'donateNow': "تبرع الآن",
          'viewAll': "مشاهدة الكل",
          'shareNutritiousFood': "شارك أغذية مغذية",
          'shareNutritiousFoodMoney': "\$709836.00",
          'shareNutritiousFoodLeftDays': "باقي ٢٧ يوم",
          'shareNutritiousFoodDonatedPercentage': "70٪ تم التبرع",
          'goal': "هدف: ",
          'shareNutritiousFoodMoneyGoal': "10000000.00 دولار",
          'popularFundraiser': "شعبية لجمع التبرعات",
          'topVolunteer': "أعلى المتطوعين",
          'donationKiosks': "أعلى المتطوعين",
          'nigerianFoundation': "المؤسسة النيجيرية",
          'funeral': "جنازة",

          //? donate now screen
          'description': "وصف",

          'msgDonatePreview': "نحن ملتزمون بتوفير التعليم "
              "لكل طفل في الهند. تبرع لتعليم الأطفال الفقراء ومنحهم هدية التعليم.",
          'descriptionDetailsOne':
          "مجهزة بمعرفة القراءة والكتابة والمهارات الحياتية الأساسية ، يمكنهم أن يكبروا ليصبحوا بالغين يكسبون"
              " أجور أعلى ، علموا أطفالهم ، ولهم صوت في مجتمعهم. سوف تساعد الأطفال على كسر الحلقة "
              "من الفقر من خلال توفير الموارد مثل: التدريس و ",
          'descriptionDetailsTwo':
          "Equipped with  literacy and essential life skills, they can grow into adults  who earn higher "
              "wages , educate  their own  children , and have a voice in their community. You'll help kids break the cycle "
              "of poverty by providing resources like: Teaching and learning materi-als in local languages . Equip-ped with "
              " literacy and essential life skills, they can grow into adults  who earn higher wages , educate  their own  "
              "child-ren , and have a voice in their commu-nity . You'll help kids break the cycle of poverty by providing"
              " resources like: Teaching and learning materi-als in local languages.",

          //? donate screen:
          'donate': "يتبرع",
          'education': "تعليم",
          'amount': "مقدار",
          'paymentGateway': "اختيار بوابة الدفع",
          'payment': "دفع",
          'yourGoal': "هدفك",
          'amountMoney': "0.00",
          'message': "رسالة",
          'optional': "اختياري",
          'paymentMethod': "طريقة الدفع او السداد",
          'myWallet': "محفظتى",
          'carNumber': "**** **** **** 9683",
          'addCard': "+Add Card",
          'donateForEdu': "تبرع لتطوير التعليم",
          'from': "من",
          'to': "إلى",
          'usd': "دولار أمريكي",

          //? payment method screen
          "charge": "تكلفة",
          "processingTime": "وقت المعالجة",
          "chargeAmount": "2.00 USD + 3%",
          "processingTimeAmount": "1 - 2 Hours",

          //? donate review screen
          "review": "إعادة النظر",
          "foundation": "مؤسسة",
          "foundationName": "جمع التبرعات من نظير إلى نظير",
          "foundationAmount": "\$50.00",

          //? donate success screen
          "success": "النجاح!",
          "successSubTitle": "شكرا لك على التبرع",
          "successDes":
          "تبرعك يعني الكثير بالنسبة لهم ويساعد في جعل العالم مكانًا أفضل.",

          //? medical screen
          "medical": "طبي",
          "nigerianMedicalDev": "التطوير الطبي النيجيري",
          "searchCampaign": "حملة البحث",
          "searchVolunteer": "بحث تطوع",

          //? popular fundraiser screen
          "americanFounding": "التأسيس الأمريكي",

          //? Donation kiosks screen
          "recentActivities": "أنشطة حالية",
          "accomplishedCampaign": "الحملة المنجزة",
          "campaignDuration": "مدة الحملة: ",
          "days": '' "أيام",
          'totalDays': "90",
          'reach': "Reach : \$",
          'reachMoney': "9805686.00",

          //? create campaign screen
          'selectCategories': "حدد الفئات",
          'createCampaign': "أنشئ حملة",
          'title': "عنوان",
          'writeHere': "اكتب هنا",
          'writeYourDescriptionForFundRise':
          "Write your Description for Fundrise",
          'image': "Image",
          'attachDocument': "إرفاق مستند (PDF)",
          'targetAmount': "الهدف",
          'campaignGoal': "هدف الحملة",
          'dueDate': "تاريخ الاستحقاق",
          'deadline': "حد اقصى",
          'dMy': "اليوم / الشهر / السنة",
          'location': "موقع",

          //?wait for approval screen
          'waitForApprovalTitle': "الانتظار للموافقة عليها",
          'waitForApprovalDes': "انتظر بعض الوقت للتحقق في لوحة الإدارة.",

          //? profile screen
          'profileName': "ليدينسون آركير",
          'profile': "الملف الشخصي",
          'profileOrg': "منظم نيجيري",
          'currentBalance': "الرصيد الحالي",
          'recentDeposit': "الإيداع الأخير",
          'recentWithdraw': "سحب حديث",
          'recentDepositMoney': "\$ 1000.00",
          'recentWithdrawMoney': "\$ 1000.00",
          'currentBalanceMoney': "\$ 106689.00",
          'myCampaign': "حملتي",
          'withdraw': "ينسحب",
          'withdrawAmount': "Withdraw Amount",

          //? deposit amount
          'paypal': "باي بال",
          'stripe': "شريط",
          'depositAmount': "قيمة الايداع",

          //? drawer screen
          'editProfile': "تعديل الملف الشخصي",
          'allCampaign': "كل الحملة",
          'myCards': "بطاقاتي",
          'myCampaigns': "حملاتي",
          'myDonations': "تبرعاتي",
          'depositLog': "سجل الإيداع",
          'settings': "إعدادات",
          'withdrawLog': "سحب السجل",
          'shareApp': "شارك التطبيق",
          'helpCenter': "مركز المساعدة",
          'aboutUs': "معلومات عنا",
          'rateUs': "قيمنا",
          'changePassword': "غير كلمة السر",
          'changeLanguage': "غير كلمة السر",
          'faSecurity': "2FA Security",
          'createNewTicket': "إنشاء تذكرة جديدة",
          'myTickets': "تذاكري",

          //? edit pro'file screen
          'editProfileEmail': "lediensonarker@gmail.com",
          'address': "تبوك",
          'editProfilePhoneNumber': "+1 659 659 6321",

          //?my cards screen
          "visaCard": "بطاقة فيزا",
          "visaCardNumber": "5689 5687 9867 2345",
          "expiryDate": "تاريخ انتهاء الصلاحية",
          "expiryDateToday": "12/2026",
          "cvc": "CVV/CVC",
          "cvcNumber": "635",
          "adDCard": "Add Card",

          //? Add card screen
          "selectCardType": "Select Card Type",
          "masterCard": "Mastercard",
          "cardDetails": "Card Details",
          "nameOfCard": "Name On Card",
          "cardNUmber": "Card Number",
          "mY": "MM/YY",

          //? my donations screen
          'myDonationsDollar': "\$50.00",

          //? change password screen
          'oldPassword': "كلمة المرور القديمة",
          'neWPassword': "كلمة السر الجديدة",
          'confirmPassword': "تأكيد كلمة المرور",

          //? change language screen
          'arabic': "Arabic",
          'english': "English",
          'bangla': "Bangla",
          'german': "German",

          //? help center screen
          'qnOne': "كيف تضيف بطاقة في ملفك الشخصي؟",
          'qnTwo': "كيف تتبرع؟",
          'qnThree': "كيف تنشئ حملة؟",
          'qnFour': "كيف أشارك حملتي في وسائل التواصل الاجتماعي؟",
          'qnFive': "How to Create Campaign?",

          //? live chat screen
          'liveChat': "Live Chat",
          'liveChatOneQn': "How can we help with xFunding?",
          'liveChatTwoQn': "How to I Donate?",
          'liveChatThreeQn':
          "First of all you need to add your Mastercard or Visa-card for payment source. Then you can Donate any Fundraiser.",
          'liveChatFourQn': "Thank you so much...",
          'composeYourMessage': "اكتب رسالتك .....",

          //? about screen
          'aboutUsPartOne':
          "Crafting a compelling job description is essential to helping you attract the most qualified candidates for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are wh",
          'aboutUsPartTwo':
          "Crafting a compelling job description is essential to helping you attract the most qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire Crafting a com pelling job description is essealtse most qualified candites for your job. With more than 25 million jobs listed Indeed, a great job description can help your jobs stan out from a rest. Your job descriptions are where you start your company and you job to your future hire.. Crafting a compelling job description is essential the mos qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire.",
          'aboutUsPartThree':
          "Crafting a compelling job description is essential to helping you attract the most qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire Crafting a com pelling job description is essealtse most qualified candites for your job. With more than 25 million jobs listed Indeed, a great job description can help your jobs stan out from a rest. Your job descriptions are where you start your company and you job to your future hire.. Crafting a compelling job description is essential the mos qualified candidates for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire. Crafting a cop qualified candidates for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire Crafting a compelling job description is essealtse most qualified candites for your job. With more than 25 million jobs listed Indeed, a great job description can help your jobs stan out from a rest. Your job descriptions are where you start your company and you job to your future hire.. Crafting a compelling job description is essential the mos qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire.",
          'aboutUsPartFour':
          "Crafting a compelling job description is essential to helping you attract the most qualified candites for your job. With more than 25 million jobs listed Indeed, a gr eat job description can help your jobs stand out from a rest. Your job description are where you start your company and you job to your future hire.",
          'copyright': "CopyRight © 2022 xFunding",
          'websiteLink': "www.xFunding.com",

          //? deposit method screen
          'depositMethod': "طريقة الإيداع",
          'limit': "حد",
          'limitMoney': "10.00 - 1000.00 USD",

          //? de'posit preview screen
          'depositPreview': "معاينة الإيداع",

          //? deposit success screen
          'successDesDeposit': "Your 100.00 USD Successfully Deposit.",

          //? withdraw method screen
          'withdrawMethod': "طريقة السحب",
          'trx': "TRX 2546RT56VSW89",
          'withdrawPreview': "سحب المعاينة",
          'successDesWithdraw': "Your 100.00 USD Successfully Withdraw.",
          'twoFactorAuthCode': "RSIK6ZDNDPVOIBVX",

          //? create new tickets
          'subject': "موضوعات",

          //? my tickets screen
          'myTicketTransaction': "TN-123456789",
          'hereIsTicketIssues': "Here is ticket issues....",
          'solved': "تم حلها",
          'pending': "قيد الانتظار",
          'pendingCampaign': "حملة معلقة",
          'rejected': "مرفوض",
          'rejectedCampaign': "حملة مرفوضة",
          'successfulCampaign': "حملة ناجحة",

          //? dashboard screen
          'dashboard': "لوحة القيادة",
          'totalCampaign': "إجمالي الحملة",
          'donationReport': "تقرير التبرع الشهري",
          'withdrawReport': "تقرير السحب الشهري",

          //? filter
          'filterCampaign': "حملة تصفية",
          'filterByCategory': "تصفية حسب الفئة",
          'filterByDate': "تصفية حسب التاريخ",

          //? success story screen
          'successStory': "قصة نجاح",

          //? success story each screen
          'comments': "10 Comments",
          'leaveAComment': "اترك تعليقا",
          'comment': "i'm thankful to them who donate money for child's",

          'views': "100 Views",
          'androidAppUrl':
          'https://play.google.com/store/apps/details?id:net.appdevs.xfundingnew',
          'iosAppUrl': '',
        },
      };
}
