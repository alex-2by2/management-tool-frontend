const {
  getStatus,
} = require(
  '../modules/maintenance/maintenance.service',
);

async function maintenanceMode(
  request,
  response,
  next,
) {
  try {
    const path =
      request.path;

    const bypass =
      path.startsWith(
        '/health',
      ) ||
      path.startsWith(
        '/maintenance',
      ) ||
      path.startsWith(
        '/api/v1/owner',
      ) ||
      path.startsWith(
        '/api/v1/auth',
      );

    if (bypass) {
      return next();
    }

    const maintenance =
      await getStatus();

    if (!maintenance.enabled) {
      return next();
    }

    return response
      .status(503)
      .json({
        success: false,
        error: {
          code:
            'MAINTENANCE_MODE',
          message:
            maintenance.message,
          title:
            maintenance.title,
          estimatedEndAt:
            maintenance
              .estimatedEndAt,
        },
      });
  } catch (error) {
    return next(error);
  }
}

module.exports =
  maintenanceMode;
