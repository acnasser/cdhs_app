import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cdhs_app/userclass.dart';

class CreateJobPosting extends StatefulWidget {
  const CreateJobPosting({Key? key}) : super(key: key);

  @override
  State<CreateJobPosting> createState() => _CreateJobPostingState();
}

class _CreateJobPostingState extends State<CreateJobPosting> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> userData = {};
  bool isLoading = false;

  // Form controllers
  final _companyNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _requiredCertsController = TextEditingController();
  final _responsibilitiesController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    try {
      Map<String, dynamic> data = await Userclass.fetchCurrentUserData();
      setState(() {
        userData = data;
        // Pre-fill location data from user profile
        _zipCodeController.text = userData['CZip'] ?? '';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _submitJobPosting() async {
    if (!_formKey.currentState!.validate()) return;

    if (userData['Employer'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only employers can post jobs')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _firestore.collection('Job Postings').add({
        'CompanyName': _companyNameController.text,
        'Description': _descriptionController.text,
        'JobTitle': _jobTitleController.text,
        'Qualifications': _qualificationsController.text,
        'RequiredCerts': _requiredCertsController.text,
        'Responsibilities': _responsibilitiesController.text,
        'WhoPosted': userData['Email'] ?? '',
        'ZipCode': _zipCodeController.text,
        'CAddress': userData['CAddress'] ?? '',
        'CState': userData['CState'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job posted successfully!')),
        );
      }

      // Clear form
      _formKey.currentState!.reset();
      _clearControllers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error posting job')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _clearControllers() {
    _companyNameController.clear();
    _descriptionController.clear();
    _jobTitleController.clear();
    _qualificationsController.clear();
    _requiredCertsController.clear();
    _responsibilitiesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check if user is an employer
    if (userData['Employer'] != true) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Only employers can post jobs',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Job Posting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _qualificationsController,
                decoration: const InputDecoration(
                  labelText: 'Qualifications *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _requiredCertsController,
                decoration: const InputDecoration(
                  labelText: 'Required Certifications',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _responsibilitiesController,
                decoration: const InputDecoration(
                  labelText: 'Responsibilities *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // Location information (read-only)
              TextFormField(
                initialValue: userData['CAddress'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: userData['CState'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'Zip Code',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitJobPosting,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Post Job',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _descriptionController.dispose();
    _jobTitleController.dispose();
    _qualificationsController.dispose();
    _requiredCertsController.dispose();
    _responsibilitiesController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
}