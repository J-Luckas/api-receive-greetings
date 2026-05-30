import { Controller, Get, Post, Body } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('good-morning')
  getGoodMorning(): string {
    return this.appService.getGoodMorning();
  }

  @Post('good-night')
  createGoodNight(@Body() body: { message: string }): string {
    return this.appService.createGoodNight(body.message);
  }
}
