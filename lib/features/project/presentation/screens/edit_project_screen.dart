import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/permissions/permission_cubit.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../cubit/edit_project_cubit.dart';
import '../cubit/edit_project_state.dart';
import '../widgets/edit_project/edit_project_actions_row.dart';
import '../widgets/edit_project/edit_project_app_bar.dart';
import '../widgets/edit_project/edit_project_data_section.dart';
import '../widgets/edit_project/edit_project_forms_section.dart';
import '../widgets/edit_project/edit_project_management_section.dart';
import '../widgets/edit_project/edit_project_supervision_section.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({super.key, required this.projectId});

  final String projectId;

  static Route<void> route({required String projectId}) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<EditProjectCubit>()..loadProject(projectId),
        child: EditProjectScreen(projectId: projectId),
      ),
    );
  }

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contractualBudgetController;
  late final TextEditingController _estimatedBudgetController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contractualBudgetController = TextEditingController();
    _estimatedBudgetController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contractualBudgetController.dispose();
    _estimatedBudgetController.dispose();
    super.dispose();
  }

  void _syncControllers(EditProjectFormData form) {
    if (_titleController.text != form.title) {
      _titleController.text = form.title;
    }
    if (_contractualBudgetController.text != form.contractualBudget) {
      _contractualBudgetController.text = form.contractualBudget;
    }
    if (_estimatedBudgetController.text != form.estimatedBudget) {
      _estimatedBudgetController.text = form.estimatedBudget;
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final message = await context.read<EditProjectCubit>().submit();
    if (!mounted || message == null) return;

    await sl<DashboardCubit>().refresh();

    if (!mounted) return;

    AppFunctions.showSuccessToast(
      context,
      message.isNotEmpty ? message : AppString.changesSavedSuccessfully.tr(),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // if (!context.read<PermissionCubit>().canEditProjects) {
    //   return Scaffold(
    //     backgroundColor: colors.kBgColor,
    //     appBar: const EditProjectAppBar(),
    //     body: Center(
    //       child: Padding(
    //         padding: EdgeInsets.all(16.w),
    //         child: Text(
    //           AppString.noPermission.tr(),
    //           textAlign: TextAlign.center,
    //           style: TextStyle(color: colors.kRedColor, fontSize: 16.sp),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return BlocConsumer<EditProjectCubit, EditProjectState>(
      listenWhen: (previous, current) {
        if (current is! EditProjectLoaded) return false;
        if (previous is! EditProjectLoaded) return true;
        return previous.form != current.form ||
            previous.submitError != current.submitError;
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
        if (state is EditProjectLoading || state is EditProjectInitial) {
          return _loadingScaffold(colors);
        }

        if (state is EditProjectError) {
          return _errorScaffold(colors, state.message);
        }

        if (state is! EditProjectLoaded) return const SizedBox.shrink();

        return _loadedScaffold(colors, state);
      },
    );
  }

  Widget _loadingScaffold(AppColorScheme colors) {
    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: const EditProjectAppBar(),
      body: Center(
        child: CircularProgressIndicator(color: colors.kPrimaryColor),
      ),
    );
  }

  Widget _errorScaffold(AppColorScheme colors, String message) {
    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: const EditProjectAppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.kRedColor),
              ),
              SizedBox(height: 16.h),
              FilledButton(
                onPressed: () => context
                    .read<EditProjectCubit>()
                    .loadProject(widget.projectId),
                child: Text(AppString.retry.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadedScaffold(AppColorScheme colors, EditProjectLoaded state) {
    final form = state.form;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: const EditProjectAppBar(),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
                EditProjectDataSection(
                  form: form,
                  titleController: _titleController,
                  contractualBudgetController: _contractualBudgetController,
                  estimatedBudgetController: _estimatedBudgetController,
                ),
                SizedBox(height: 16.h),
                EditProjectSupervisionSection(form: form),
                SizedBox(height: 16.h),
                EditProjectManagementSection(form: form),
                SizedBox(height: 16.h),
                EditProjectFormsSection(form: form),
                SizedBox(height: 24.h),
                EditProjectActionsRow(
                  isSubmitting: state.isSubmitting,
                  onSave: _submit,
                ),     SizedBox(height: 24.h),
              ],
            ),
          ),
          if (state.isSubmitting)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.15),
                child: Center(
                  child: CircularProgressIndicator(
                    color: colors.kPrimaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
