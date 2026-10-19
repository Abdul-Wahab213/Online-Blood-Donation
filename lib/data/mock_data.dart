class UserItem {
  final String id, name, role, email, phone, loc, reg, k1, v1, k2, v2, k3, v3;
  const UserItem(
    this.id,
    this.name,
    this.role,
    this.email,
    this.phone,
    this.loc,
    this.reg,
    this.k1,
    this.v1,
    this.k2,
    this.v2,
    this.k3,
    this.v3,
  );
  String get initials => name.split(' ').map((w) => w[0]).take(2).join();
}

const kUsers = <UserItem>[
  UserItem(
    'U-1001',
    'Ali Khan',
    'Donor',
    'ali@email.com',
    '+92 300 1234567',
    'Islamabad',
    '12 Jan 2026',
    'Blood Group',
    'O+',
    'Last Donation',
    '02 Aug 2026',
    'Donations',
    '6',
  ),
  UserItem(
    'U-1002',
    'Sara Ahmed',
    'Patient',
    'sara@email.com',
    '+92 301 2223344',
    'Rawalpindi',
    '03 Mar 2026',
    'Blood Requests',
    '3',
    'Last Request',
    'BR-1019',
    'History',
    '2 completed',
  ),
  UserItem(
    'U-1003',
    'Shifa International',
    'Hospital',
    'info@shifa.org.pk',
    '+92 51 8464646',
    'Islamabad',
    '20 Feb 2026',
    'Verification',
    'Verified',
    'Beds',
    '550',
    'Inventory',
    '312 units',
  ),
  UserItem(
    'U-1004',
    'Red Crescent BB',
    'Blood Bank',
    'bb@redcrescent.pk',
    '+92 51 9250404',
    'Islamabad',
    '11 Apr 2026',
    'Verification',
    'Verified',
    'Staff',
    '24',
    'Inventory',
    '1,240 units',
  ),
  UserItem(
    'U-1005',
    'Bilal Raza',
    'Donor',
    'bilal@email.com',
    '+92 333 7654321',
    'Lahore',
    '28 May 2026',
    'Blood Group',
    'A+',
    'Last Donation',
    '15 Jun 2026',
    'Donations',
    '2',
  ),
];

class BloodRequest {
  final String id, patient, group;
  final int units;
  final String hospital, location, date, priority, status;
  const BloodRequest(
    this.id,
    this.patient,
    this.group,
    this.units,
    this.hospital,
    this.location,
    this.date,
    this.priority,
    this.status,
  );
}

const kRequests = <BloodRequest>[
  BloodRequest(
    'BR-1024',
    'Ali Khan',
    'O+',
    2,
    'Shifa Hospital',
    'Islamabad',
    '05 Oct 2026',
    'Emergency',
    'Pending',
  ),
  BloodRequest(
    'BR-1023',
    'Maryam Noor',
    'A-',
    3,
    'PIMS',
    'Islamabad',
    '04 Oct 2026',
    'Urgent',
    'Accepted',
  ),
  BloodRequest(
    'BR-1022',
    'Usman Tariq',
    'B+',
    1,
    'Holy Family',
    'Rawalpindi',
    '03 Oct 2026',
    'Normal',
    'Completed',
  ),
  BloodRequest(
    'BR-1021',
    'Hira Aslam',
    'O-',
    4,
    'Kulsum Hospital',
    'Islamabad',
    '02 Oct 2026',
    'Emergency',
    'Pending',
  ),
  BloodRequest(
    'BR-1020',
    'Zain Abbas',
    'AB+',
    2,
    'CMH',
    'Rawalpindi',
    '01 Oct 2026',
    'Normal',
    'Cancelled',
  ),
];

class MatchedDonor {
  final String name, group, km, availability, lastDonation;
  const MatchedDonor(
    this.name,
    this.group,
    this.km,
    this.availability,
    this.lastDonation,
  );
  String get initials => name.split(' ').map((w) => w[0]).join();
}

const kMatchedDonors = <MatchedDonor>[
  MatchedDonor('Ali Khan', 'O+', '1.2', 'Available', '02 Aug 2026'),
  MatchedDonor('Omar Farooq', 'O+', '3.4', 'Available', '11 Jul 2026'),
  MatchedDonor('Hina Malik', 'O+', '5.0', 'Busy', '24 Jun 2026'),
];

class DonationItem {
  final String id, name, group, hospital, date, units, status;
  const DonationItem(
    this.id,
    this.name,
    this.group,
    this.hospital,
    this.date,
    this.units,
    this.status,
  );
}

const kDonations = <DonationItem>[
  DonationItem(
    'DN-501',
    'Ali Khan',
    'O+',
    'Shifa Hospital',
    '05 Oct',
    '1',
    'Completed',
  ),
  DonationItem(
    'DN-502',
    'Bilal Raza',
    'A+',
    'PIMS',
    '06 Oct',
    '1',
    'Scheduled',
  ),
  DonationItem(
    'DN-503',
    'Hina Malik',
    'B+',
    'Red Crescent BB',
    '03 Oct',
    '2',
    'Completed',
  ),
  DonationItem(
    'DN-504',
    'Omar Farooq',
    'O-',
    'CMH',
    '02 Oct',
    '1',
    'Cancelled',
  ),
];

class NotificationItem {
  final String title, message, category;
  const NotificationItem(this.title, this.message, this.category);
}

const kNotifications = <NotificationItem>[
  NotificationItem(
    'Emergency Blood Request',
    'O- blood request requires urgent attention.',
    'Emergency',
  ),
  NotificationItem(
    'New Donor Verification',
    'Ahmed Khan submitted verification.',
    'Verification',
  ),
  NotificationItem(
    'Inventory Alert',
    'O- blood stock is critically low.',
    'Inventory',
  ),
  NotificationItem('System Update', 'Weekly report is ready.', 'System'),
];

class InvGroup {
  final String group;
  final int available, reserved;
  const InvGroup(this.group, this.available, this.reserved);
  String get status => available < 30
      ? 'Critical'
      : available < 60
      ? 'Low'
      : 'Normal';
  double get fraction =>
      ((available / 4).round() / 100).clamp(0.0, 1.0).toDouble();
}

const kInventory = <InvGroup>[
  InvGroup('A+', 320, 40),
  InvGroup('A-', 58, 12),
  InvGroup('B+', 210, 25),
  InvGroup('B-', 36, 8),
  InvGroup('AB+', 74, 10),
  InvGroup('AB-', 22, 5),
  InvGroup('O+', 380, 50),
  InvGroup('O-', 42, 18),
];

class VerificationItem {
  final String key, name, subtitle, kind; // kind: Donor, Hospital, Blood Bank
  final List<MapEntry<String, String>> rows;
  VerificationItem(this.key, this.name, this.subtitle, this.kind, this.rows);
  String get initials => name.split(' ').map((w) => w[0]).take(2).join();
}

VerificationItem _donor(
  String key,
  String n,
  String bg,
  int age,
  String loc,
  String reg,
) {
  return VerificationItem(key, n, '$bg · Age $age · $loc', 'Donor', [
    MapEntry('Blood group', bg),
    MapEntry('Age', '$age'),
    MapEntry('Location', loc),
    MapEntry('Registered', reg),
    const MapEntry('Donation history', 'No previous donations'),
    const MapEntry('Eligibility', 'Weight 68 kg · Hb 13.5 · Eligible'),
    const MapEntry('ID document', 'CNIC uploaded'),
  ]);
}

VerificationItem _org(String n, String kind, String loc, String email) {
  return VerificationItem('o$n', n, '$kind · $loc · Reg 01 Sep 2026', kind, [
    MapEntry('Type', kind),
    MapEntry('Address', loc),
    const MapEntry('Contact', '+92 21 3456789'),
    MapEntry('Email', email),
    const MapEntry('License', 'Document uploaded'),
    const MapEntry('Inventory', '0 units'),
  ]);
}

final kDonorVerifications = <VerificationItem>[
  _donor('d0', 'Ahmed Khan', 'O+', 24, 'Islamabad', '10 Sep 2026'),
  _donor('d1', 'Zara Sheikh', 'A+', 29, 'Lahore', '12 Sep 2026'),
  _donor('d2', 'Imran Ali', 'B-', 31, 'Karachi', '14 Sep 2026'),
];

final kOrgVerifications = <VerificationItem>[
  _org('Pakistan Eye Bank Hospital', 'Hospital', 'Lahore', 'info@pakistan.pk'),
  _org('Al-Shifa Medical Centre', 'Hospital', 'Islamabad', 'info@al-shifa.pk'),
  _org('LifeCare Blood Bank', 'Blood Bank', 'Karachi', 'info@lifecare.pk'),
  _org('City Blood Bank', 'Blood Bank', 'Peshawar', 'info@city.pk'),
];
