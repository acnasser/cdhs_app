import 'package:cdhs_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String _userType = ''; // Determine if user is Employer or Job Seeker
  final _formKey = GlobalKey<FormState>();

  // Controllers for employer fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _omFNameController = TextEditingController();
  final TextEditingController _omLNameController = TextEditingController();
  final TextEditingController _omEmailController = TextEditingController();
  final TextEditingController _omPhoneController = TextEditingController();
  final TextEditingController _cAddressController = TextEditingController();
  final TextEditingController _cStateController = TextEditingController();
  final TextEditingController _cZipController = TextEditingController();

  // Controllers for job seeker fields
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Are you an Employer or a Job Seeker?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userType = 'employer';
                    });
                  },
                  child: const Text('Employer'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userType = 'jobSeeker';
                    });
                  },
                  child: const Text('Job Seeker'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_userType.isNotEmpty) ...[
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: _userType == 'employer'
                        ? _buildEmployerForm()
                        : _buildJobSeekerForm(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Account'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmployerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Employer Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _companyNameController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.isEmpty ? 'Company Name is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _companyEmailController,
          decoration: const InputDecoration(
            labelText: 'Company Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value!.isEmpty ? 'Company Email is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) => value!.isEmpty ? 'Password is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _omFNameController,
          decoration: const InputDecoration(
            labelText: 'Office Manager First Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value!.isEmpty ? 'Office Manager First Name is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _omLNameController,
          decoration: const InputDecoration(
            labelText: 'Office Manager Last Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value!.isEmpty ? 'Office Manager Last Name is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _omEmailController,
          decoration: const InputDecoration(
            labelText: 'Office Manager Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) =>
              value!.isEmpty ? 'Office Manager Email is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _cAddressController,
          decoration: const InputDecoration(
            labelText: 'Company Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.isEmpty ? 'Address is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _cStateController,
          decoration: const InputDecoration(
            labelText: 'Company State',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.isEmpty ? 'State is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _cZipController,
          decoration: const InputDecoration(
            labelText: 'Company Zip Code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value!.isEmpty ? 'Zip Code is required' : null,
        ),
      ],
    );
  }

  Widget _buildJobSeekerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Job Seeker Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _fNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.isEmpty ? 'First Name is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _lNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.isEmpty ? 'Last Name is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value!.isEmpty ? 'Email is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) => value!.isEmpty ? 'Password is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => value!.isEmpty ? 'Phone Number is required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _dobController,
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            hintText: 'MM/DD/YYYY',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) => value!.isEmpty ? 'Date of Birth is required' : null,
        ),
      ],
    );
  }


Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      // Create user account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _userType == 'employer'
            ? _companyEmailController.text 
            : _emailController.text, 
        password: _passwordController.text,
      );

      // Save user data to Firestore
      await firestore.collection('Users').doc(userCredential.user!.uid).set({
        'CAddress': _userType == 'employer' ? _cAddressController.text : '',
        'CState': _userType == 'employer' ? _cStateController.text : '',
        'CZip': _userType == 'employer' ? _cZipController.text : '',
        'CompanyEmail': _userType == 'employer' ? _companyEmailController.text : '',
        'CompanyName': _userType == 'employer' ? _companyNameController.text : '',
        'DOB': _userType == 'jobSeeker' ? _dobController.text : '',
        'Email': _userType == 'employer' ? _companyEmailController.text : _emailController.text,
        'Employer': _userType == 'employer',
        'FName': _userType == 'employer' ? _omFNameController.text : _fNameController.text,
        'LName': _userType == 'employer' ? _omLNameController.text : _lNameController.text,
        'JobSeeker': _userType == 'jobSeeker',
        'OMEmail': _userType == 'employer' ? _omEmailController.text : '',
        'OMFName': _userType == 'employer' ? _omFNameController.text : '',
        'OMLName': _userType == 'employer' ? _omLNameController.text : '',
        'Phone': _userType == 'jobSeeker' ? _phoneController.text : _omPhoneController.text,
      });

      if (userCredential.user != null) {
        // Navigate to a success page or home screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email is already in use. Please try another.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid. Please check and try again.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    
    

  }
  

  // Circling back to the login screen
  // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
}


  // Disposing of controllers, I guess this is to free up resources
  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _companyNameController.dispose();
    _companyEmailController.dispose();
    _omFNameController.dispose();
    _omLNameController.dispose();
    _omEmailController.dispose();
    _omPhoneController.dispose();
    _cAddressController.dispose();
    _cStateController.dispose();
    _cZipController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}

