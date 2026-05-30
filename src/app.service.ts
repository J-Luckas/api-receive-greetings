import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Good night!';
  }

  getGoodMorning(): string {
    return 'Good morning!';
  }

  createGoodNight(message: string): string {
    return `Good night! ${message}`;
  }
}
