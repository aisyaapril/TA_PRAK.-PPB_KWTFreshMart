/**
 * home controller
 */

import { factories } from '@strapi/strapi'

export default factories.createCoreController('api::home.home', ({strapi}) => ({
    async find(ctx) {
        const sanitizedQueryParams = await this.sanitizeQuery(ctx);
        const { results, pagination } = await strapi.service('api::home.home').find({
            populate: { gambar: true },
        });
        const sanitizedResults = await this.sanitizeOutput(results, ctx);
    
        return this.transformResponse(sanitizedResults, { pagination });
    },

    async findOne(ctx) {
        const { slug } = ctx.params; // Ambil parameter slug
        console.log('Slug:', slug); // Debugging parameter slug

        const entity = await strapi.db.query('api::home.home').findOne({
            where: { slug }, // Query berdasarkan slug
            populate: { gambar: true }, // Populate field gambar
        });
        console.log('Entity:', entity); // Debugging respons query

        if (!entity) {
            return ctx.notFound('Home not found'); // Data tidak ditemukan
        }

        const sanitizedResults = await this.sanitizeOutput(entity, ctx);

        return this.transformResponse(sanitizedResults);
    },
}));
