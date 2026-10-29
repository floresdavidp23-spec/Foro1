from infrastructure.database.connection import get_connection
from Foro1.WebSocket.domain.entities.FeaturesModels import FeatureCreate, FeatureUpdate


class FeatureRepository:

    def insert_feature(self, feature: FeatureCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Features]
                @i_featureSummary = ?,
                @i_featureDescription = ?,
                @i_featuresAcceptanceCriteria = ?,
                @i_featureOwner = ?,
                @i_featureParentLink = ?,
                @i_featurePriority = ?,
                @i_featureStartDate = ?,
                @i_featureDueDate = ?,
                @i_featureCreatorId = ?,
                @i_featureStatus = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            feature.featureSummary,
            feature.featureDescription,
            feature.featuresAcceptanceCriteria,
            feature.featureOwner,
            feature.featureParentLink,
            feature.featurePriority,
            feature.featureStartDate,
            feature.featureDueDate,
            feature.featureCreatorId,
            feature.featureStatus,
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        result = cursor.fetchone()

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": result[0] if result else o_Numero,
            "message": result[1] if result else o_MensajeUsuario
        }


    def update_feature(self, feature: FeatureUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Features]
                @i_featureId = ?,
                @i_featureSummary = ?,
                @i_featureDescription = ?,
                @i_featuresAcceptanceCriteria = ?,
                @i_featureOwner = ?,
                @i_featureParentLink = ?,
                @i_featurePriority = ?,
                @i_featureStartDate = ?,
                @i_featureDueDate = ?,
                @i_featureModificatorId = ?,
                @i_featureStatus = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            feature.featureId,
            feature.featureSummary,
            feature.featureDescription,
            feature.featuresAcceptanceCriteria,
            feature.featureOwner,
            feature.featureParentLink,
            feature.featurePriority,
            feature.featureStartDate,
            feature.featureDueDate,
            feature.featureModificatorId,
            feature.featureStatus,
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        result = cursor.fetchone()

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": result[0] if result else o_Numero,
            "message": result[1] if result else o_MensajeUsuario
        }


    def list_features(self):
        """
        Lista todas las features (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Features]
                @w_Accion = 'S',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": o_Numero,
            "message": o_MensajeUsuario,
            "data": data
        }