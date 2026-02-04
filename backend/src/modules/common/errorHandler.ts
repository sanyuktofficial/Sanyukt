import { NextFunction, Request, Response } from 'express';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export function errorHandler(
  err: any,
  _req: Request,
  res: Response,
  _next: NextFunction,
) {
  // eslint-disable-next-line no-console
  console.error(err);

  const status = err.statusCode ?? 500;
  const message = err.message ?? 'Unexpected server error';

  res.status(status).json({
    success: false,
    message,
  });
}

