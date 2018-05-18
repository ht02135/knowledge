ALTER TABLE [dbo].[BATCH_STEP_EXECUTION] DROP CONSTRAINT [JOB_EXEC_STEP_FK]
ALTER TABLE [dbo].[BATCH_JOB_PARAMS] DROP CONSTRAINT [JOB_INST_PARAMS_FK]
ALTER TABLE [dbo].[BATCH_JOB_EXECUTION] DROP CONSTRAINT [JOB_INST_EXEC_FK]
TRUNCATE TABLE  [dbo].[BATCH_STEP_EXECUTION_SEQ]
TRUNCATE TABLE  [dbo].[BATCH_JOB_SEQ]
TRUNCATE TABLE  [dbo].[BATCH_JOB_EXECUTION_SEQ]
TRUNCATE TABLE [dbo].[BATCH_JOB_PARAMS]
TRUNCATE TABLE  [dbo].[BATCH_EXECUTION_CONTEXT]
TRUNCATE TABLE  [dbo].[BATCH_JOB_INSTANCE]
TRUNCATE TABLE  [dbo].[BATCH_JOB_EXECUTION]
TRUNCATE TABLE [dbo].[BATCH_STEP_EXECUTION]
ALTER TABLE [dbo].[BATCH_JOB_EXECUTION]  WITH CHECK ADD  CONSTRAINT [JOB_INST_EXEC_FK] FOREIGN KEY([JOB_INSTANCE_ID]) REFERENCES [dbo].[BATCH_JOB_INSTANCE] ([JOB_INSTANCE_ID])
ALTER TABLE [dbo].[BATCH_JOB_EXECUTION] CHECK CONSTRAINT [JOB_INST_EXEC_FK]
ALTER TABLE [dbo].[BATCH_JOB_PARAMS]  WITH CHECK ADD  CONSTRAINT [JOB_INST_PARAMS_FK] FOREIGN KEY([JOB_INSTANCE_ID]) REFERENCES [dbo].[BATCH_JOB_INSTANCE] ([JOB_INSTANCE_ID])
ALTER TABLE [dbo].[BATCH_JOB_PARAMS] CHECK CONSTRAINT [JOB_INST_PARAMS_FK]
ALTER TABLE [dbo].[BATCH_STEP_EXECUTION]  WITH CHECK ADD  CONSTRAINT [JOB_EXEC_STEP_FK] FOREIGN KEY([JOB_EXECUTION_ID]) REFERENCES [dbo].[BATCH_JOB_EXECUTION] ([JOB_EXECUTION_ID])
ALTER TABLE [dbo].[BATCH_STEP_EXECUTION] CHECK CONSTRAINT [JOB_EXEC_STEP_FK]