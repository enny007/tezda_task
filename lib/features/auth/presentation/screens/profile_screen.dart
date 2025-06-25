import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tezda_task/core/constants/app_constants.dart';
import 'package:tezda_task/core/utils/toast_service.dart';
import 'package:tezda_task/core/utils/validators.dart';
import 'package:tezda_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:tezda_task/features/auth/presentation/providers/auth_state.dart';
import 'package:tezda_task/features/auth/presentation/widgets/auth_form_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  void _initializeControllers() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      _nameController.text = currentUser.name ?? '';
      _emailController.text = currentUser.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = ref.watch(currentUserProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      final toastService = ref.read(toastServiceProvider);

      if (next.status == AuthStatus.unauthenticated) {
        context.go(AppConstants.loginRoute);
        toastService.showSuccessToast(
          title: 'Logged Out',
          message: 'You have been successfully logged out.',
        );
      } else if (next.status == AuthStatus.error) {
        toastService.showErrorToast(
          title: 'Error',
          message: next.errorMessage ?? 'An error occurred',
        );
      } else if (previous?.status == AuthStatus.loading &&
          next.status == AuthStatus.authenticated &&
          _isEditing) {
        setState(() {
          _isEditing = false;
        });
        toastService.showSuccessToast(
          title: 'Profile Updated',
          message: 'Your profile has been updated successfully!',
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(currentUser),
            const SizedBox(height: 32),

            // Profile Form
            if (_isEditing) ...[
              _buildEditForm(authState),
            ] else ...[
              _buildProfileInfo(currentUser),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Profile Picture - Simple Icon
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),

          // User Name
          Text(
            user?.name ?? 'No Name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // User Email
          Text(
            user?.email ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthFormField(
            controller: _nameController,
            labelText: 'Full Name',
            validator: Validators.validateName,
            prefixIcon: const Icon(Icons.person_outlined),
          ),
          const SizedBox(height: 16),

          AuthFormField(
            controller: _emailController,
            labelText: 'Email',
            enabled: false, // Email cannot be changed
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: authState.isLoading ? null : _cancelEdit,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _saveProfile,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(user) {
    return Column(
      children: [
        _buildInfoCard(
          icon: Icons.person_outlined,
          title: 'Full Name',
          value: user?.name ?? 'Not provided',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.email_outlined,
          title: 'Email',
          value: user?.email ?? '',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.calendar_today_outlined,
          title: 'Member Since',
          value: user?.createdAt != null
              ? _formatDate(user!.createdAt!)
              : 'Unknown',
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
          );
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
    _initializeControllers(); // Reset form fields
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
