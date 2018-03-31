import { configure, getLogger } from 'log4js';
// configure('./filename');
const logger = getLogger();
logger.level = 'debug';
logger.debug('Some debug messages');

// https://www.npmjs.com/package/log4js
// https://github.com/log4js-node/log4js-example/blob/master/config/log4js.json

configure({
    appenders: { cheese: { type: 'file', filename: 'cheese.log' } },
    categories: { default: { appenders: ['cheese'], level: 'error' } }
});

const appLogger = logger;
export { appLogger };