CREATE TRIGGER DEMO
ON EVIDENCIJA_RACUNA
AFTER UPDATE,DELETE
AS
BEGIN
PRINT 'Mijenjanje podataka nije dozvoljeno'
ROLLBACK TRANSACTION
END
GO
