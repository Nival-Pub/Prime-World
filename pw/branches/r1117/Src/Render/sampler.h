#pragma once

#include "texture.h"
#include "states.h"


namespace Render
{
	

	/// �������
	class Sampler
	{
	public:
    struct SignificantPart
    {
      HDRColor multiplier;
      HDRColor add;
      SamplerState samplerState;
      void*    pTexture;
    };

		static const uint MAX_PS_SAMPLER_INDEX = 15;
		static const uint MIN_PS_SAMPLER_INDEX = 0;
		static const uint MAX_VS_SAMPLER_INDEX = 260;
		static const uint MIN_VS_SAMPLER_INDEX = 257;
		///
    // Sampler() {}
		/// ����������
		//virtual ~Sampler() {}

		/// ��������� ������� ��������
		void GetSignificantPart(SignificantPart *_res) const;
		/// ��������� ������� ��������
		const SamplerState& GetSamplerState() const { return samplerState; }
		/// ��������� ������� ��������
		SamplerState& GetSamplerState() { return samplerState; }
		/// ��������� ������� ��������
		void SetSamplerState(const NDb::SamplerState& state) { samplerState = SamplerState(state); }

		/// ��������� ��������
		void SetTexture( Texture * pTexture_ ) { pTexture = pTexture_; }
		/// ��������� ��������
		const TextureRef& GetTexture() const { return pTexture; }
		///
		void Bind(int samplerIndex) const;

		void SetMultiplierAndAdd(const HDRColor& _multiplier, const HDRColor& _add)
		{
			multiplier = _multiplier;
			add        = _add;

			samplerState.SetHasModifiers(true);
		}

		bool GetMultiplierAndAdd(HDRColor& _multiplier, HDRColor& _add) const
		{
			_multiplier = multiplier;
			_add = add;
      return HasModifiers();
		}
    bool HasModifiers() const { return samplerState.HasModifiers(); }
    bool Enabled()      const { return samplerState.Enabled(); }
    void Enable(bool _enable) { samplerState.SetEnableMode(_enable ? SamplerState2::Enable : SamplerState2::Disable); }

    Sampler& operator=(const Sampler& _src)
    {
      pTexture = _src.pTexture;
      samplerState =_src.samplerState;
      if( _src.HasModifiers() ) {
        multiplier = _src.multiplier;
        add = _src.add;
      }
      return *this;
    }

	private:
    HDRColor multiplier;
    HDRColor add;

    SamplerState2 samplerState;
    TextureRef    pTexture;
	};
}; // namespace Render