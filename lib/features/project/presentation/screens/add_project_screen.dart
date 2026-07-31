import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../cubit/edit_project_cubit.dart';
import '../cubit/edit_project_state.dart';
import '../widgets/edit_project/add_project_form_validator.dart';
import '../widgets/edit_project/edit_project_actions_row.dart';
import '../widgets/edit_project/edit_project_app_bar.dart';
import '../widgets/edit_project/edit_project_data_section.dart';
import '../widgets/edit_project/edit_project_forms_section.dart';
import '../widgets/edit_project/edit_project_management_section.dart';
import '../widgets/edit_project/edit_project_supervision_section.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<EditProjectCubit>()..initForCreate(),
        child: const AddProjectScreen(),
      ),
    );
  }

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _projectCodeController;
  late final TextEditingController _contractualBudgetController;
  late final TextEditingController _estimatedBudgetController;
  bool _showValidationErrors = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _projectCodeController = TextEditingController();
    _contractualBudgetController = TextEditingController();
    _estimatedBudgetController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _projectCodeController.dispose();
    _contractualBudgetController.dispose();
    _estimatedBudgetController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _syncControllers(EditProjectFormData form) {
    if (_titleController.text != form.title) {
      _titleController.text = form.title;
    }
    if (_descriptionController.text != form.description) {
      _descriptionController.text = form.description;
    }
    if (_projectCodeController.text != form.projectCode) {
      _projectCodeController.text = form.projectCode;
    }
    if (_contractualBudgetController.text != form.contractualBudget) {
      _contractualBudgetController.text = form.contractualBudget;
    }
    if (_estimatedBudgetController.text != form.estimatedBudget) {
      _estimatedBudgetController.text = form.estimatedBudget;
    }
  }

  EditProjectFormData _syncedForm(EditProjectFormData form) {
    return form.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      projectCode: _projectCodeController.text.trim(),
      contractualBudget: _contractualBudgetController.text.trim(),
      estimatedBudget: _estimatedBudgetController.text.trim(),
    );
  }

  Future<void> _submit() async {
    final cubit = context.read<EditProjectCubit>();
    final state = cubit.state;
    if (state is! EditProjectLoaded) return;

    final synced = _syncedForm(state.form);
    cubit.updateForm(synced);

    setState(() => _showValidationErrors = true);

    await Future<void>.delayed(Duration.zero);

    if (!mounted) return;

    final missing = AddProjectFormValidator.missingLabels(synced);
    final formValid = _formKey.currentState?.validate() ?? false;

    if (missing.isNotEmpty || !formValid) {
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

      AppFunctions.showsToast(
        AddProjectFormValidator.toastMessage(missing),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    final message = await cubit.submit();
    if (!mounted || message == null) return;

    await sl<DashboardCubit>().refresh();

    if (!mounted) return;

    AppFunctions.showSuccessToast(
      context,
      message.isNotEmpty ? message : AppString.changesSavedSuccessfully.tr(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocConsumer<EditProjectCubit, EditProjectState>(
      listenWhen: (previous, current) {
        if (current is! EditProjectLoaded) return false;
        if (current.submitError == null) return false;
        if (previous is! EditProjectLoaded) return true;
        return previous.submitError != current.submitError;
      },
      listener: (context, state) {
        if (state is EditProjectLoaded) {
          _syncControllers(state.form);
          if (state.submitError != null) {
            AppFunctions.showsToast(
              state.submitError!,
              AppColor.kRedColor,
              context,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is! EditProjectLoaded) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: EditProjectAppBar(title: AppString.addNewProject.tr()),
            body: Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            ),
          );
        }

        final form = state.form;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: EditProjectAppBar(title: AppString.addNewProject.tr()),
            body: Form(
              key: _formKey,
              autovalidateMode: _showValidationErrors
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                children: [
                  EditProjectDataSection(
                    form: form,
                    requiredFields: true,
                    showValidationErrors: _showValidationErrors,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    projectCodeController: _projectCodeController,
                    contractualBudgetController: _contractualBudgetController,
                    estimatedBudgetController: _estimatedBudgetController,
                  ),
                  SizedBox(height: 16.h),
                  EditProjectSupervisionSection(
                    form: form,
                    requiredFields: true,
                    showValidationErrors: _showValidationErrors,
                  ),
                  SizedBox(height: 16.h),
                  EditProjectManagementSection(
                    form: form,
                    requiredFields: true,
                    showValidationErrors: _showValidationErrors,
                  ),
                  SizedBox(height: 16.h),
                  EditProjectFormsSection(form: form),
                  SizedBox(height: 24.h),
                  EditProjectActionsRow(
                    isSubmitting: state.isSubmitting,
                    onSave: _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
