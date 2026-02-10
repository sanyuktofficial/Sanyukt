/// Country -> State -> Cities mapping for location dropdowns.
/// India: all 28 states + 8 UTs with cities.
const Map<String, Map<String, List<String>>> locationMap = {
  'India': {
    'Andhra Pradesh': [
      'Visakhapatnam', 'Vijayawada', 'Guntur', 'Tirupati', 'Kurnool',
      'Nellore', 'Kakinada', 'Rajahmundry', 'Kadapa', 'Anantapur',
    ],
    'Arunachal Pradesh': ['Itanagar', 'Tawang', 'Ziro', 'Pasighat', 'Naharlagun', 'Tezu'],
    'Assam': [
      'Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat', 'Nagaon',
      'Tinsukia', 'Tezpur', 'Bongaigaon', 'Dhubri', 'Diphu',
    ],
    'Bihar': [
      'Patna', 'Gaya', 'Muzaffarpur', 'Bhagalpur', 'Darbhanga',
      'Purnia', 'Munger', 'Bihar Sharif', 'Arrah', 'Katihar',
    ],
    'Chhattisgarh': [
      'Raipur', 'Bhilai', 'Bilaspur', 'Korba', 'Durg',
      'Rajnandgaon', 'Raigarh', 'Ambikapur', 'Jagdalpur',
    ],
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda'],
    'Gujarat': [
      'Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar',
      'Jamnagar', 'Junagadh', 'Gandhinagar', 'Anand', 'Nadiad',
    ],
    'Haryana': [
      'Gurgaon', 'Faridabad', 'Panipat', 'Ambala', 'Yamunanagar',
      'Rohtak', 'Hisar', 'Karnal', 'Sonipat', 'Bhiwani',
    ],
    'Himachal Pradesh': [
      'Shimla', 'Manali', 'Dharamshala', 'Solan', 'Mandi',
      'Palampur', 'Baddi', 'Nahan', 'Kullu', 'Chamba',
    ],
    'Jharkhand': [
      'Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar',
      'Hazaribagh', 'Giridih', 'Ramgarh', 'Phusro', 'Medininagar',
    ],
    'Karnataka': [
      'Bengaluru', 'Mysuru', 'Mangaluru', 'Hubli', 'Belagavi',
      'Shivamogga', 'Tumakuru', 'Ballari', 'Vijayapura', 'Raichur',
    ],
    'Kerala': [
      'Kochi', 'Thiruvananthapuram', 'Kozhikode', 'Thrissur', 'Kollam',
      'Alappuzha', 'Palakkad', 'Malappuram', 'Kannur', 'Kasaragod',
    ],
    'Madhya Pradesh': [
      'Bhopal', 'Indore', 'Gwalior', 'Jabalpur', 'Ujjain',
      'Sagar', 'Dewas', 'Satna', 'Ratlam', 'Rewa',
    ],
    'Maharashtra': [
      'Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad',
      'Solapur', 'Kolhapur', 'Amravati', 'Nanded', 'Sangli',
    ],
    'Manipur': ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur', 'Kakching'],
    'Meghalaya': ['Shillong', 'Tura', 'Nongstoin', 'Jowai', 'Williamnagar'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Champhai', 'Serchhip', 'Kolasib'],
    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Tuensang', 'Wokha'],
    'Odisha': [
      'Bhubaneswar', 'Cuttack', 'Rourkela', 'Puri', 'Berhampur',
      'Sambalpur', 'Balasore', 'Bhadrak', 'Baripada', 'Jeypore',
    ],
    'Punjab': [
      'Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala', 'Bathinda',
      'Mohali', 'Pathankot', 'Hoshiarpur', 'Batala', 'Moga',
    ],
    'Rajasthan': [
      'Jaipur', 'Udaipur', 'Jodhpur', 'Kota', 'Bikaner',
      'Ajmer', 'Bhilwara', 'Alwar', 'Bharatpur', 'Sikar',
    ],
    'Sikkim': ['Gangtok', 'Namchi', 'Gyalshing', 'Mangan', 'Ravangla'],
    'Tamil Nadu': [
      'Chennai', 'Coimbatore', 'Madurai', 'Salem', 'Tiruchirappalli',
      'Tirunelveli', 'Erode', 'Vellore', 'Thoothukudi', 'Dindigul',
    ],
    'Telangana': [
      'Hyderabad', 'Warangal', 'Nizamabad', 'Karimnagar', 'Khammam',
      'Mahbubnagar', 'Nalgonda', 'Adilabad', 'Suryapet', 'Siddipet',
    ],
    'Tripura': ['Agartala', 'Udaipur', 'Dharmanagar', 'Kailasahar', 'Belonia'],
    'Uttar Pradesh': [
      'Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Noida',
      'Meerut', 'Allahabad', 'Bareilly', 'Aligarh', 'Moradabad',
    ],
    'Uttarakhand': [
      'Dehradun', 'Haridwar', 'Nainital', 'Roorkee', 'Haldwani',
      'Rudrapur', 'Kashipur', 'Rishikesh', 'Pithoragarh', 'Mussoorie',
    ],
    'West Bengal': [
      'Kolkata', 'Howrah', 'Durgapur', 'Siliguri', 'Asansol',
      'Bardhaman', 'Malda', 'Baharampur', 'Habra', 'Kharagpur',
    ],
    // Union Territories
    'Andaman and Nicobar Islands': ['Port Blair', 'Diglipur', 'Rangat'],
    'Chandigarh': ['Chandigarh'],
    'Dadra and Nagar Haveli and Daman and Diu': ['Daman', 'Diu', 'Silvassa'],
    'Delhi': ['New Delhi', 'North Delhi', 'South Delhi', 'East Delhi', 'West Delhi'],
    'Jammu and Kashmir': ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla', 'Sopore'],
    'Ladakh': ['Leh', 'Kargil', 'Nubra', 'Zanskar'],
    'Lakshadweep': ['Kavaratti', 'Agatti', 'Minicoy', 'Andrott'],
    'Puducherry': ['Puducherry', 'Karaikal', 'Yanam', 'Mahe'],
  },
};

/// Country names for dropdown.
List<String> get countries => locationMap.keys.toList()..sort();

/// States for a country. Returns empty list if country not found.
List<String> getStates(String country) {
  final states = locationMap[country]?.keys.toList() ?? [];
  states.sort();
  return states;
}

/// Cities for a country and state. Returns empty list if not found.
List<String> getCities(String country, String state) {
  final cities = locationMap[country]?[state] ?? [];
  return List<String>.from(cities)..sort();
}
