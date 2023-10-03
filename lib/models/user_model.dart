class Users {
  final String uid;
  final String name;
  final String phone_number;
  final String cnic;
  final String cnic_image_back_url;
  final String cnic_image_front_url;
  final String profile_image_url;




  Users({
    required this.uid,
    required this.name,
    required this.phone_number,
    required this.cnic,
    required this.cnic_image_back_url,
    required this.cnic_image_front_url,
    required this.profile_image_url,

  });
  Users copyWith({
    String? uid,
    String? name,
    String? phone_number,
    String? cnic,
    String? cnic_image_back_url,
    String? cnic_image_front_url,
    String? profile_image_url,

  }) {
    return Users(
      uid: '',
      name: '',
      phone_number: '',
      cnic: '',
      cnic_image_back_url: '',
      cnic_image_front_url: '',
      profile_image_url: '',


      //createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid':uid,
      'name':name,
      'phone_number': phone_number,
      'cnic':cnic,
      'cnic_image_front_url':cnic_image_front_url,
      'cnic_image_back_url':cnic_image_back_url,
      'profile_image_url':profile_image_url



    };
  }
}