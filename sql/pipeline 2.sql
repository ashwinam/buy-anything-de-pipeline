-- Create watermark table for incremental loading
-- This going to hold the last date from salesOrder table
CREATE TABLE watermark_dateholder(
    last_date DATE
);

-- Validate table is created or not
SELECT * FROM watermark_dateholder;

-- Get the minimum date from salesOrder
SELECT MIN(OrderDate) FROM salesOrder; 
-- Got 23-06-2023 but need to add -1 so that way we include current initial date.

-- Insert -1 date into watermark-table
INSERT INTO watermark_dateholder VALUES ('2023-06-22');

-- Add the stored procedure for changing data for watermark table.

CREATE PROCEDURE update_watermark_dateholder_table
@lastload DATE
AS
    BEGIN
        BEGIN TRANSACTION
            UPDATE watermark_dateholder
            SET last_date = @lastload;
        COMMIT TRANSACTION
    END;

-- Error came so need to give the permission
GRANT EXECUTE
ON OBJECT::dbo.update_watermark_dateholder_table
TO de_pipeline_user;

-- Checking the permission
SELECT
    HAS_PERMS_BY_NAME(
        'dbo.update_watermark_dateholder_table',
        'OBJECT',
        'EXECUTE'
    ) AS HasExecutePermission;