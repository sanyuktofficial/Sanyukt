import { Router } from 'express';
import { authMiddleware } from '../common/authMiddleware';
import { listCategories, listUsersByCategory, listUsersByCategoryLegacy, getUserDetail, getStats } from './audience.controller';

export const audienceRouter = Router();

audienceRouter.get('/categories', authMiddleware, listCategories);
audienceRouter.get('/users', authMiddleware, listUsersByCategory);
audienceRouter.get('/users/:categoryId', authMiddleware, listUsersByCategoryLegacy);
audienceRouter.get('/user/:userId', authMiddleware, getUserDetail);
audienceRouter.get('/stats', authMiddleware, getStats);

