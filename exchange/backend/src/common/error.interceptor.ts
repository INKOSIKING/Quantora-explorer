import {
  Injectable, NestInterceptor, ExecutionContext, CallHandler, HttpException, Catch, ArgumentsHost,
  ExceptionFilter
} from '@nestjs/common';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable()
export class ErrorInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      catchError(err => {
        if (err instanceof HttpException) {
          return throwError(() => err);
        }
        return throwError(() => new HttpException('Internal server error', 500));
      }),
    );
  }
}

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const status = exception instanceof HttpException ? exception.getStatus() : 500;
    const message = exception instanceof HttpException
      ? exception.getResponse()
      : 'Internal server error';
    response.status(status).json({
      status,
      message,
      timestamp: new Date().toISOString(),
    });
  }
}