import { app } from './app';
import { connectMongo } from './config/mongo';
import { env } from './config/env';

async function bootstrap() {
  await connectMongo();

  app.listen(env.port, '0.0.0.0', () => {
    // eslint-disable-next-line no-console
    console.log(`Server listening on port ${env.port}`);
  });
}

bootstrap().catch((err) => {
  // eslint-disable-next-line no-console
  console.error('Failed to start server', err);
  process.exit(1);
});

