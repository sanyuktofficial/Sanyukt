import cors from 'cors';
import express from 'express';
import { authRouter } from './modules/auth/auth.routes';
import { audienceRouter } from './modules/audience/audience.routes';
import { errorHandler } from './modules/common/errorHandler';
import { userRouter } from './modules/user/user.routes';

export const app = express();

app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

app.use('/auth', authRouter);
app.use('/user', userRouter);
app.use('/audience', audienceRouter);

app.use(errorHandler);

