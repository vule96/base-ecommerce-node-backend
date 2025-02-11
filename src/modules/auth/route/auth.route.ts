import express, { Router } from 'express';
import { validatorMiddleware } from '~/middlewares/validator.middleware';
import { authController } from '~/modules/auth/controller/auth.controller';
import { userLoginDTOSchema, userRegistrationDTOSchema } from '~/modules/user/schema/user.schema';

const router: Router = express.Router();

export function authRoutes(): Router {
  router.post('/login', validatorMiddleware(userLoginDTOSchema), authController.login);
  router.post('/register', validatorMiddleware(userRegistrationDTOSchema), authController.register);
  return router;
}
