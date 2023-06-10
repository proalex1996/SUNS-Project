
class VerifySMSOTPInput {
    VerifySMSOTPInput({
        this.phoneNumber,
        this.otp,
    });

    String phoneNumber;
    String otp;

    factory VerifySMSOTPInput.fromJson(Map<String, dynamic> json) => VerifySMSOTPInput(
        phoneNumber: json["phoneNumber"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "otp": otp,
    };
}

class SendSMSOTPInput {
    SendSMSOTPInput({
        this.phoneNumber,
    });

    String phoneNumber;

    factory SendSMSOTPInput.fromJson(Map<String, dynamic> json) => SendSMSOTPInput(
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
    };
}
