# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shopify::ProductTagBuilder do
  describe '#build' do
    subject(:builder) { described_class.new(product) }

    let(:store) { create(:store) }
    let(:manufacturer) { create(:manufacturer, name: 'Nike', store: store) }
    let(:parent_category) { create(:category, name: 'Sports', store: store) }
    let(:child_category) { create(:category, name: 'Chaussures de Course', category: parent_category, store: store) }
    let(:product) do
      create(:product,
             name: 'Running Shoes',
             quantity: 10,
             manufacturer: manufacturer,
             category: child_category,
             store: store)
    end

    context 'with a product that has all attributes' do
      before do
        # Attach an image to the product
        product.images.attach(
          io: StringIO.new('fake image'),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
      end

      it 'generates all expected tags' do
        tags = builder.build

        expect(tags).to include('stock:in-stock')
        expect(tags).to include('image:with-image')
        expect(tags).to include('manufacturer:nike')
        expect(tags).to include('category:chaussures-de-course')
        expect(tags).to include('category:sports')
      end

      it 'returns unique tags only' do
        tags = builder.build
        expect(tags).to eq(tags.uniq)
      end

      it 'returns tags as an array of strings' do
        tags = builder.build
        expect(tags).to be_an(Array)
        expect(tags).to all(be_a(String))
      end
    end

    context 'when generating stock level tags' do
      it 'returns "stock:in-stock" when quantity is positive' do
        product.update(quantity: 5)
        tags = builder.build
        expect(tags).to include('stock:in-stock')
        expect(tags).not_to include('stock:out-of-stock')
      end

      it 'returns "stock:out-of-stock" when quantity is zero' do
        product.update(quantity: 0)
        tags = builder.build
        expect(tags).to include('stock:out-of-stock')
        expect(tags).not_to include('stock:in-stock')
      end

      it 'returns "stock:out-of-stock" when quantity is negative' do
        product.update(quantity: -5)
        tags = builder.build
        expect(tags).to include('stock:out-of-stock')
        expect(tags).not_to include('stock:in-stock')
      end
    end

    context 'when generating image presence tags' do
      it 'returns "image:with-image" when product has images' do
        product.images.attach(
          io: StringIO.new('fake image'),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
        tags = builder.build
        expect(tags).to include('image:with-image')
        expect(tags).not_to include('image:without-image')
      end

      it 'returns "image:without-image" when product has no images' do
        tags = builder.build
        expect(tags).to include('image:without-image')
        expect(tags).not_to include('image:with-image')
      end
    end

    context 'when generating manufacturer tags' do
      it 'returns slugified manufacturer tag' do
        tags = builder.build
        expect(tags).to include('manufacturer:nike')
      end

      it 'handles manufacturer names with special characters' do
        manufacturer.update(name: 'Société Française & Co.')
        tags = builder.build
        expect(tags).to include('manufacturer:societe-francaise-co')
      end

      it 'handles manufacturer names with accents' do
        manufacturer.update(name: 'Café André')
        tags = builder.build
        expect(tags).to include('manufacturer:cafe-andre')
      end

      it 'does not include manufacturer tag when manufacturer is nil' do
        product.update(manufacturer: nil)
        tags = builder.build
        expect(tags.grep(/^manufacturer:/).any?).to be false
      end

      it 'does not include manufacturer tag when manufacturer name is blank' do
        manufacturer.update(name: '')
        tags = builder.build
        expect(tags.grep(/^manufacturer:/).any?).to be false
      end
    end

    context 'when generating category hierarchy tags' do
      it 'includes all categories in the hierarchy' do
        tags = builder.build
        expect(tags).to include('category:chaussures-de-course')
        expect(tags).to include('category:sports')
      end

      it 'handles three-level category hierarchy' do
        grandparent = create(:category, name: 'Équipement', store: store)
        parent_category.update(category: grandparent)

        tags = builder.build
        expect(tags).to include('category:chaussures-de-course')
        expect(tags).to include('category:sports')
        expect(tags).to include('category:equipement')
      end

      it 'handles single-level category (no parent)' do
        product.update(category: parent_category)
        tags = builder.build
        expect(tags).to include('category:sports')
        expect(tags).not_to include('category:chaussures-de-course')
      end

      it 'slugifies category names correctly' do
        category = create(:category, name: "Vêtements d'Hiver", store: store)
        product.update(category: category)
        tags = builder.build
        expect(tags).to include('category:vetements-d-hiver')
      end

      it 'returns empty array when category is nil' do
        product.update(category: nil)
        tags = builder.build
        expect(tags.grep(/^category:/).any?).to be false
      end
    end

    context 'when using slugify method' do
      it 'converts text to lowercase kebab-case' do
        expect(builder.send(:slugify, 'Hello World')).to eq('hello-world')
      end

      it 'removes special characters' do
        expect(builder.send(:slugify, 'Test & Co.')).to eq('test-co')
      end

      it 'handles accented characters' do
        expect(builder.send(:slugify, 'Café André')).to eq('cafe-andre')
      end

      it 'returns nil for blank text' do
        expect(builder.send(:slugify, '')).to be_nil
        expect(builder.send(:slugify, nil)).to be_nil
      end

      it 'handles multiple spaces' do
        expect(builder.send(:slugify, 'Multiple   Spaces')).to eq('multiple-spaces')
      end
    end

    context 'when logging' do
      it 'logs the generated tags' do
        allow(Rails.logger).to receive(:info)
        builder.build
        expect(Rails.logger).to have_received(:info).with(/Generated Shopify tags for product_id=#{product.id}/)
      end
    end
  end
end
